#!/usr/bin/env python3

from __future__ import annotations

import re
import sys
from pathlib import Path


ESCAPED_ID_RE = re.compile(r"(?<=\()\\\\([^()]*)\\ ")
ESCAPED_CHAR_RE = re.compile(r"\\([\[\]<>^/])")


def normalize_symbol(symbol: str) -> str:
    symbol = ESCAPED_CHAR_RE.sub(r"\1", symbol)
    return symbol


def normalize_saif(text: str) -> str:
    def replace_escaped_id(match: re.Match[str]) -> str:
        return normalize_symbol(match.group(1))

    text = ESCAPED_ID_RE.sub(replace_escaped_id, text)
    text = normalize_symbol(text)
    return text


def main(argv: list[str]) -> int:
    if len(argv) != 3:
        print("usage: normalize_saif.py <input.saif> <output.saif>", file=sys.stderr)
        return 2

    src = Path(argv[1])
    dst = Path(argv[2])

    text = src.read_text(encoding="utf-8", errors="strict")
    normalized = normalize_saif(text)
    dst.write_text(normalized, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

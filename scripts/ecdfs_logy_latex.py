#!/usr/bin/env python3
"""Regenerate the ECDF plot with logarithmic y-axis and LaTeX-rendered fonts."""
from pathlib import Path

import matplotlib

matplotlib.use("Agg")

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.ticker import FixedLocator, FixedFormatter, LogLocator, NullFormatter


ROOT = Path(__file__).resolve().parent
OUT = ROOT / "figures" / "cdfs" / "ecdfs_logy_latex.pdf"
CURVE_FALLBACK = ROOT / "figures" / "cdfs" / "ecdf_curves.csv"
RAW = {
    "UNSW": ROOT / "datas" / "unsw_binarynetv5_stats.csv",
    "MNIST": ROOT / "datas" / "mnist_binarynetv5_stats.csv",
    "JST": ROOT / "datas" / "jst_binarynetv5_stats.csv",
}
PROB_LABELS = {"UNSW": 0.034, "MNIST": 0.026, "JST": 0.229}
STYLES = {
    "UNSW": {"color": "#000000", "linestyle": "-", "linewidth": 1.35},
    "MNIST": {"color": "#005AB5", "linestyle": "--", "linewidth": 1.35},
    "JST": {"color": "#D55E00", "linestyle": "-.", "linewidth": 1.35},
}
ORDER = ["UNSW", "MNIST", "JST"]


def configure_latex_style() -> None:
    plt.rcParams.update({
        "text.usetex": True,
        "font.family": "serif",
        "font.serif": ["Computer Modern Roman"],
        "axes.unicode_minus": False,
        "font.size": 7.5,
        "axes.labelsize": 8.0,
        "xtick.labelsize": 7.0,
        "ytick.labelsize": 7.0,
        "legend.fontsize": 6.6,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
        "text.latex.preamble": r"\usepackage{amsmath}",
    })


def load_from_raw() -> pd.DataFrame | None:
    frames = []
    for name, path in RAW.items():
        if not path.exists():
            return None
        try:
            df = pd.read_csv(path, usecols=["pre_act", "threshold"])
        except Exception:
            return None
        df["pre_act"] = pd.to_numeric(df["pre_act"], errors="coerce")
        df["threshold"] = pd.to_numeric(df["threshold"], errors="coerce")
        df = df.dropna(subset=["pre_act", "threshold"])
        if df.empty:
            return None
        m = np.sort(np.abs(df["threshold"].to_numpy() - df["pre_act"].to_numpy()))
        y = np.arange(1, len(m) + 1) / len(m)
        frames.append(pd.DataFrame({"dataset": name, "t": m, "ecdf": y}))
    return pd.concat(frames, ignore_index=True)


def main() -> None:
    configure_latex_style()
    data = load_from_raw()
    if data is None:
        data = pd.read_csv(CURVE_FALLBACK)

    fig, ax = plt.subplots(figsize=(3.45, 2.25))
    for name in ORDER:
        d = data[data["dataset"] == name].sort_values("t")
        d = d[(d["t"] > 0) & (d["t"] <= 1000) & (d["ecdf"] > 0)]
        ax.plot(
            d["t"],
            d["ecdf"],
            label=fr"\textrm{{{name}}} ($\Pr \leq 1 = {PROB_LABELS[name]:.3f}$)",
            **STYLES[name],
        )

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlim(0.1, 1000)
    ax.set_ylim(1e-3, 1.05)

    ax.xaxis.set_major_locator(FixedLocator([0.1, 0.3, 1, 10, 100, 1000]))
    ax.xaxis.set_major_formatter(
        FixedFormatter([r"$0.1$", r"$0.3$", r"$1$", r"$10$", r"$100$", r"$1000$"])
    )
    ax.xaxis.set_minor_locator(LogLocator(base=10, subs=np.arange(2, 10) * 0.1, numticks=100))
    ax.xaxis.set_minor_formatter(NullFormatter())

    ax.yaxis.set_major_locator(FixedLocator([1e-3, 1e-2, 1e-1, 1]))
    ax.yaxis.set_major_formatter(
        FixedFormatter([r"$10^{-3}$", r"$10^{-2}$", r"$10^{-1}$", r"$1$"])
    )
    ax.yaxis.set_minor_locator(LogLocator(base=10, subs=np.arange(2, 10) * 0.1, numticks=100))
    ax.yaxis.set_minor_formatter(NullFormatter())

    ax.axvline(1.0, color="black", linewidth=1.0, linestyle="-", zorder=5)
    ax.set_xlabel(r"Tolerance $t$ (for $|\tau-y|$)")
    ax.set_ylabel(r"ECDF $\Pr(|\tau-y|\leq t)$")
    ax.legend(
        loc="lower left",
        bbox_to_anchor=(0.0, 1.015),
        frameon=False,
        borderaxespad=0.0,
        handlelength=2.8,
        labelspacing=0.25,
    )
    fig.subplots_adjust(left=0.19, right=0.995, bottom=0.19, top=0.76)
    OUT.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT, bbox_inches="tight", pad_inches=0.02)
    plt.close(fig)
    print(f"Plot saved to: {OUT}")


if __name__ == "__main__":
    main()

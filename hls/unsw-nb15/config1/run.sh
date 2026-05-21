#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$CONFIG_DIR/../../.." && pwd)"

cd "$CONFIG_DIR"
"$ROOT/scripts/run_hls_config.sh"

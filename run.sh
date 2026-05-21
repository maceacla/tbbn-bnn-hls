#!/bin/bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
HLS_ROOT="$ROOT/hls"
configs=(
   "mnist/config1"
   "mnist/config2"
   "mnist/config3"
   "mnist/config4"
   "mnist/config5"
   "mnist/config6"
   "jst/config1"
   "jst/config2"
   "jst/config3"
   "jst/config4"
   "jst/config5"
   "unsw-nb15/config1"
   "unsw-nb15/config2"
   "unsw-nb15/config3"
   "unsw-nb15/config4"
   "unsw-nb15/config5"
)
for rel in "${configs[@]}"; do
  echo "=== Running csynth+impl+pr for $rel ==="
  (
    cd "$HLS_ROOT/$rel"
    ./run.sh
  )
done

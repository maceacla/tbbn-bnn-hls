#!/usr/bin/env bash
set -Eeuo pipefail

saif_tcl="${1:-log_saif_from_timing_simulation.tcl}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: required command not found on PATH: $1" >&2
    exit 127
  fi
}

require_file() {
  if [ ! -f "$1" ]; then
    echo "ERROR: required file is missing: $1" >&2
    exit 1
  fi
}

cleanup_project() {
  if [ -d binarynet ] && command -v lsof >/dev/null 2>&1; then
    mapfile -t pids < <(lsof +D binarynet 2>/dev/null | awk 'NR>1 {print $2}' | sort -u)
    if ((${#pids[@]})); then
      kill -9 "${pids[@]}" || true
    fi
  fi

  rm -rf binarynet
}

move_tool_logs() {
  shopt -s nullglob
  local files=(vivado* vitis*)
  if ((${#files[@]})); then
    mv "${files[@]}" logs/
  fi
  shopt -u nullglob
}

require_cmd vivado
require_cmd vitis-run
require_cmd python3

require_file csynth_impl_pr.tcl
require_file "$saif_tcl"
require_file power_from_saif.tcl
require_file normalize_saif.py
require_file tb/tb_binarynet.v

mkdir -p logs reports
rm -rf logs/*
rm -rf reports/*

vivado_version="$(vivado -version 2>&1 | head -n 1)"
vitis_version="$(vitis-run --version 2>&1 | head -n 1)"
if [ -z "$vitis_version" ]; then
  vitis_version="$(command -v vitis-run)"
fi

echo "Using Vivado: $vivado_version"
echo "Using Vitis HLS: $vitis_version"

cleanup_project

vitis-run --mode hls --tcl csynth_impl_pr.tcl
vivado -mode batch -source "$saif_tcl"
vivado -mode batch -source power_from_saif.tcl

move_tool_logs

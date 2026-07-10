# Threshold-Based Batch Normalization for Integer Only Binarized Neural Network Inference

This repository is a supporting package for the IEEE ESL manuscript.

## Contents

- `hls/`: HLS implementations for the MNIST, JST, and UNSW-NB15 workloads.
- `hls/*/config*/src/`: C/C++ HLS source files.
- `hls/*/config*/tb/`: Verilog testbenches used for SAIF and power reruns.
- `hls/*/config*/*.tcl`: Vitis HLS, Vivado implementation, SAIF, and power scripts.
- `hls/*/config*/reports/`: generated SAIF and power reports (not versioned).
- `datas/`: generated ECDF and margin/statistics CSV files (not versioned).
- `scripts/`: Python scripts for ECDF, margin, scatter, and summary-statistic plots.
- `stats.md`: paper-facing FPGA metric snapshot.
- `run.sh`: top-level helper for rerunning all HLS configurations.

The trained network weights and exported thresholds are embedded directly in the
HLS parameter headers, primarily the `*_params.h` files under each configuration
source directory.

## Generated Data Policy

This repository contains the source needed to reproduce the results, not generated
data or tool outputs. CSV datasets under `datas/`, per-configuration `reports/`
directories, SAIF files, implementation reports, bitstreams, and hardware export
files are intentionally excluded from version control. This keeps source archives
small and avoids requiring Git LFS for a reproducible release.

`stats.md` is the compact, paper-facing record of the reported FPGA metrics.

## Reproducing HLS Results

The HLS flow requires AMD/Xilinx Vivado 2025.1 and Vitis HLS 2025.1 on `PATH`.
The checked-in results in `stats.md` were prepared from Vivado/Vitis HLS reruns
targeting the Alveo U250 device `xcu250-figd2104-2L-e`.

To rerun one configuration:

```bash
cd hls/mnist/config1
./run.sh
```

To rerun all configurations:

```bash
./run.sh
```

The top-level script runs every HLS configuration. Each configuration recreates its generated
`binarynet/`, `logs/`, and `reports/` outputs from the checked-in source,
testbench, and TCL files.

## ECDF And Statistics

The ECDF and diagnostic scripts operate on regenerated CSV files placed in
`datas/`. These generated inputs and any resulting plots are not part of the
source archive.
Create a virtual environment and install the Python dependencies from
`pyproject.toml` before running them:

```bash
python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install .
```

Examples:

```bash
python3 scripts/ecdfs.py
python3 scripts/ecdfs_logy_latex.py
python3 scripts/calculate_statistics.py datas/mnist_binarynetv5_stats.csv
```

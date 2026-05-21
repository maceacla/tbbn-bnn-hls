# Threshold-Based Batch Normalization for Integer Only Binarized Neural Network Inference

This repository is a supporting package for the IEEE ESL manuscript.

## Contents

- `hls/`: HLS implementations for the MNIST, JST, and UNSW-NB15 workloads.
- `hls/*/config*/src/`: C/C++ HLS source files.
- `hls/*/config*/tb/`: Verilog testbenches used for SAIF and power reruns.
- `hls/*/config*/*.tcl`: Vitis HLS, Vivado implementation, SAIF, and power scripts.
- `hls/*/config*/reports/`: selected checked-in reports.
- `datas/`: ECDF and margin/statistics CSV files used by the diagnostic scripts.
- `scripts/`: Python scripts for ECDF, margin, scatter, and summary-statistic plots.
- `stats.md`: paper-facing FPGA metric snapshot.
- `run.sh`: top-level helper for rerunning all HLS configurations.

The trained network weights and exported thresholds are embedded directly in the
HLS parameter headers, primarily the `*_params.h` files under each configuration
source directory.

## Large Files

Large CSV and artifact files are tracked with Git LFS. After cloning, install Git
LFS and fetch the large files:

```bash
git lfs install
git lfs pull
```

The `datas/*.csv` files are intentionally part of the reproducibility package and
are stored through Git LFS instead of ordinary Git blobs.

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

The top-level script fetches Git LFS payloads when Git LFS is available, then
runs every HLS configuration. Each configuration recreates its generated
`binarynet/`, `logs/`, and `reports/` outputs from the checked-in source,
testbench, and TCL files.

## ECDF And Statistics

The ECDF and diagnostic scripts operate on the CSV files in `datas/`.
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

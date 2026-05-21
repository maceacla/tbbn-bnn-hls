#!/usr/bin/env python3

# make_margin_distribution_plot.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os

# --- Plot styling (LaTeX) ---
plt.rcParams.update({
  "text.usetex": True,
  "font.family": "serif",
  "font.serif": ["Computer Modern"],
  "font.size": 10,
})

# --- Paths ---
# csv_path = os.path.expanduser("~/Documents/Threshold-Based-Batch-Normalization-for-Integer-Only-Binarized-Neural-Network-Inference/MNISTBNN.csv")
# csv_path = os.path.expanduser("~/Documents/Threshold-Based-Batch-Normalization-for-Integer-Only-Binarized-Neural-Network-Inference/JSTBNN.csv")
csv_path = os.path.expanduser("~/Documents/Threshold-Based-Batch-Normalization-for-Integer-Only-Binarized-Neural-Network-Inference/UNSWBNN.csv")

figures_dir = os.path.dirname(csv_path)
os.makedirs(figures_dir, exist_ok=True)

# --- Infer dataset name from CSV filename ---
dataset_name = os.path.splitext(os.path.basename(csv_path))[0]

# --- Load CSV (ALL samples, ALL layers, ALL neurons) ---
df = pd.read_csv(csv_path)
df["pre_act"] = pd.to_numeric(df["pre_act"], errors="coerce")
df["threshold"] = pd.to_numeric(df["threshold"], errors="coerce")
df = df.dropna(subset=["pre_act", "threshold"]).copy()

# --- Margin: threshold - pre-activation ---
margins = (df["threshold"] - df["pre_act"]).to_numpy()

# --- Global stats (FULL distribution) ---
mean_m = float(np.mean(margins))
std_m  = float(np.std(margins))

pct_1  = 100.0 * float(np.mean(np.abs(margins) < 1.0))
pct_5  = 100.0 * float(np.mean(np.abs(margins) < 5.0))
pct_10 = 100.0 * float(np.mean(np.abs(margins) < 10.0))

print(f"{dataset_name}: margin distribution over ALL samples/layers/neurons")
print(f"  margin mean = {mean_m:.4f}, std = {std_m:.4f}")
print(f"  |margin| < 1  : {pct_1:.2f}%")
print(f"  |margin| < 5  : {pct_5:.2f}%")
print(f"  |margin| < 10 : {pct_10:.2f}%")

# --- Restrict to ±3 std for plotting ---
limit = 3.0 * std_m
margins_3s = margins[np.abs(margins - mean_m) <= limit]

print(f"  plotting range: [{mean_m - limit:.2f}, {mean_m + limit:.2f}]")
print(f"  fraction shown: {100.0 * len(margins_3s) / len(margins):.2f}%")

# --- Figure sizing (golden ratio) ---
golden_ratio = (5**0.5 - 1) / 2
width = 6
height = width * golden_ratio

# --- Plot ONE distribution (±3σ only) ---
num_bins = 300
plt.figure(figsize=(width, height))
plt.hist(
  margins_3s,
  bins=num_bins,
  range=(mean_m - limit, mean_m + limit),
  density=True,
  alpha=0.85,
  edgecolor="none",
)

# Reference lines
plt.axvline(0, color="black", linewidth=0.8, linestyle="--")
plt.axvline(1, color="black", linewidth=0.5, linestyle=":")
plt.axvline(-1, color="black", linewidth=0.5, linestyle=":")

plt.xlabel(r"\textbf{Margin} $\;(\tau - y)$")
plt.ylabel(r"\textbf{Density}")
plt.grid(True, linestyle=":", linewidth=0.5)
plt.tight_layout()

out_path = os.path.join(figures_dir, f"margin_dist_{dataset_name}.pdf")
plt.savefig(out_path, dpi=300, bbox_inches="tight")
plt.close()

print(f"Saved: {out_path}")
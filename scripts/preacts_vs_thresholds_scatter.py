#!/usr/bin/env python3

# make_activations_and_thresholds_plot.py
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import re

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
dataset_name = os.path.splitext(os.path.basename(csv_path))[0]  # e.g. MNISTBNN or JSTBNN

# --- Load & select sample 0 ---
df = pd.read_csv(csv_path)
df["pre_act"] = pd.to_numeric(df["pre_act"], errors="coerce")
df["threshold"] = pd.to_numeric(df["threshold"], errors="coerce")
df = df[df["sample"] == 0].dropna(subset=["pre_act", "threshold"]).copy()

# --- Detect and sort layer names like L1, L2, ... ---
def layer_key(s: str):
  m = re.search(r"(\d+)", str(s))
  return int(m.group(1)) if m else 10**9

layers = sorted(df["layer"].unique().tolist(), key=layer_key)

# --- Figure sizing (golden ratio) ---
golden_ratio = (5**0.5 - 1) / 2
width = 6
height = width * golden_ratio

for layer in layers:
  d = df[df["layer"] == layer].copy()
  x = d["pre_act"].to_numpy()
  y = d["threshold"].to_numpy()

  # --- Console stats ---
  mean_x, std_x = np.mean(x), np.std(x)
  mean_y, std_y = np.mean(y), np.std(y)
  abs_diff = np.abs(x - y)
  num_near = int(np.sum(abs_diff < 1.0))
  total = len(abs_diff)
  pct_near = 100.0 * num_near / total if total else 0.0

  print(f"Layer {layer} (sample 0, {dataset_name})")
  print(f"  Activations: mean={mean_x:.4f}, std={std_x:.4f}")
  print(f"  Thresholds : mean={mean_y:.4f}, std={std_y:.4f}")
  print(f"  Min/Max threshold: {np.min(y):.4f} / {np.max(y):.4f}")
  print(f"  |pre_act - threshold| < 1.0 : {num_near} / {total} ({pct_near:.2f}%)\n")

  # --- SINGLE PLOT (full range) ---
  plt.figure(figsize=(width, height))
  plt.scatter(x, y, color="black", alpha=1.0, s=10, edgecolors="none")
  full_min = float(min(np.min(x), np.min(y)))
  full_max = float(max(np.max(x), np.max(y)))
  pad = 0.02 * max(1.0, full_max - full_min)
  x_min, x_max = full_min - pad, full_max + pad
  line_x = np.linspace(x_min, x_max, 500)
  plt.fill_between(line_x, line_x - 1, line_x + 1, color="grey", alpha=0.6)
  plt.plot(line_x, line_x - 1, color="black", linewidth=0.6, linestyle="-")
  plt.plot(line_x, line_x + 1, color="black", linewidth=0.6, linestyle="-")
  plt.axhline(0, color="black", linewidth=0.6, linestyle="-")
  plt.axvline(0, color="black", linewidth=0.6, linestyle="-")
  plt.xlabel(r"\textbf{Pre-Activation Value} ($y$)")
  plt.ylabel(r"\textbf{Threshold Value} ($\tau$)")
  plt.grid(True, linestyle=":", linewidth=0.5)
  plt.tight_layout()
  plt.savefig(
    os.path.join(figures_dir, f"scatter_{layer}_{dataset_name}.pdf"),
    dpi=300,
    bbox_inches="tight",
  )
  plt.close()
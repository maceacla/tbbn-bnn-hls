#!/usr/bin/env python3

# calc_activation_threshold_stats.py
import pandas as pd
import numpy as np
import os
import re

# --- Paths ---
# csv_path = os.path.expanduser(
#   "~/Documents/Threshold-Based-Batch-Normalization-for-Integer-Only-Binarized-Neural-Network-Inference/MNISTBNN.csv"
# )
csv_path = os.path.expanduser(
  "~/Documents/Threshold-Based-Batch-Normalization-for-Integer-Only-Binarized-Neural-Network-Inference/JSTBNN.csv"
)

# --- Infer dataset name from CSV filename ---
dataset_name = os.path.splitext(os.path.basename(csv_path))[0]  # e.g. MNISTBNN or JSTBNN

# --- Load all data ---
df = pd.read_csv(csv_path)
df["pre_act"] = pd.to_numeric(df["pre_act"], errors="coerce")
df["threshold"] = pd.to_numeric(df["threshold"], errors="coerce")
df = df.dropna(subset=["pre_act", "threshold"]).copy()

# --- Detect and sort layer names like L1, L2, ... ---
def layer_key(s: str):
  m = re.search(r"(\d+)", str(s))
  return int(m.group(1)) if m else 10**9

layers = sorted(df["layer"].unique().tolist(), key=layer_key)

# --- Compute statistics ---
for layer in layers:
  d = df[df["layer"] == layer].copy()
  x = d["pre_act"].to_numpy()
  y = d["threshold"].to_numpy()

  mean_x, std_x = np.mean(x), np.std(x)
  mean_y, std_y = np.mean(y), np.std(y)

  abs_diff = np.abs(x - y)
  num_near = int(np.sum(abs_diff < 1.0))
  total = len(abs_diff)
  pct_near = 100.0 * num_near / total if total else 0.0

  print(f"Layer {layer} ({dataset_name})")
  print(f"  Activations: mean={mean_x:.4f}, std={std_x:.4f}")
  print(f"  Thresholds : mean={mean_y:.4f}, std={std_y:.4f}")
  print(f"  Min/Max threshold: {np.min(y):.4f} / {np.max(y):.4f}")
  print(f"  |pre_act - threshold| < 1.0 : {num_near} / {total} ({pct_near:.2f}%)\n")
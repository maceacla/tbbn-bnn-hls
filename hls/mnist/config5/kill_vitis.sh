#!/bin/bash
lsof +D binarynet 2>/dev/null | awk 'NR>1 {print $2}' | sort -u | xargs -r kill -9
rm -rf vitis_log*

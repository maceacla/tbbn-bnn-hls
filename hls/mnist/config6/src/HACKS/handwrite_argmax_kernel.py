file_path = "src/r_10n1.cpp"
module_code = """#include "ap_int.h"
void r_10n1(ap_int<16> &data0, ap_uint<1> data1[10]) {
    #pragma HLS PIPELINE II=1
    #pragma HLS ARRAY_PARTITION complete variable=data1
    ap_int<16> val = data1[0];
    ap_int<5> idx = 0;
    for (int i = 1; i < 10; i++) {
        #pragma HLS UNROLL
        if (data1[i] > val) {
            val = data1[i];
            idx = i;
        }
    }
    data0 = idx;
}
"""
# Append the new module to the file
with open(file_path, "a") as file:
  file.write(module_code)
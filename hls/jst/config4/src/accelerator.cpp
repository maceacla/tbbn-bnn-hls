#include "ap_axi_sdata.h"
#include "hls_stream.h"
#include "r_128_196_4.h"
#include "r_128_32_4_a.h"
#include "r_128_32_4_b.h"
#include "r_10_32_4.h"
#include "r_10n1.h"
#include "ap_int.h"

void read_and_unpack(hls::stream<ap_axiu<128, 1, 1, 1>>& data_in, ap_int<2> data1[784]) {
    #pragma HLS INLINE
    const int PACKETS = (784 + 127) / 128;
    for (int pkt = 0; pkt < PACKETS; pkt++) {
        #pragma HLS PIPELINE II=1
        ap_axiu<128, 1, 1, 1> input = data_in.read();
        ap_uint<128> data = input.data;
        for (int j = 0; j < 128; j++) {
            #pragma HLS UNROLL factor=32
            int idx = pkt * 128 + j;
            if (idx < 784) {
                ap_uint<1> bit = data[j];
                data1[idx] = (bit == 0) ? -1 : 1;
            }
        }
    }
}

void write_output(hls::stream<ap_axiu<32, 1, 1, 1>>& data_out, ap_int<16> data) {
    ap_axiu<32, 1, 1, 1> output;
    output.data = data;
    output.keep = -1;
    output.strb = -1;
    output.user = 0;
    output.id = 0;
    output.dest = 0;
    output.last = 1;
    data_out.write(output);
}

void Accelerator(hls::stream<ap_axiu<32, 1, 1, 1>>& data_out, hls::stream<ap_axiu<128, 1, 1, 1>>& data_in) {
    #pragma HLS INTERFACE ap_ctrl_none port=return
    #pragma HLS INTERFACE axis depth=1 port=data_in
    #pragma HLS INTERFACE axis depth=1 port=data_out
    ap_int<2> data1[784];
    read_and_unpack(data_in, data1);
    ap_int<2> data0_1[128];
    r_128_196_4(data0_1, data1);
    ap_int<2> data0_2[128];
    r_128_32_4_a(data0_2, data0_1);
    ap_int<2> data0_3[128];
    r_128_32_4_b(data0_3, data0_2);
    ap_int<2> data0_4[10];
    r_10_32_4(data0_4, data0_3);
    ap_int<16> data0_5;
    r_10n1(data0_5, data0_4);
    write_output(data_out, data0_5);
}

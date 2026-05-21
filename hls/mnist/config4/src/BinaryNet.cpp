#include "ap_axi_sdata.h"
#include "hls_stream.h"
#include "r_128_196_4.h"
#include "r_128_32_4_a.h"
#include "r_128_32_4_b.h"
#include "r_10_32_4.h"
#include "r_10n1.h"
#include "ap_int.h"

void BinaryNet(ap_int<16> &data0, ap_int<2> data1[784]) {
    ap_int<2> data0_1[128];
    r_128_196_4(data0_1, data1);
    ap_int<2> data0_2[128];
    r_128_32_4_a(data0_2, data0_1);
    ap_int<2> data0_3[128];
    r_128_32_4_b(data0_3, data0_2);
    ap_int<2> data0_4[10];
    r_10_32_4(data0_4, data0_3);
    r_10n1(data0, data0_4);
}
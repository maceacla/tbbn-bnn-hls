#include "ap_axi_sdata.h"
#include "hls_stream.h"
#include "r_64_593.h"
#include "r_16_4.h"
#include "ap_int.h"

void binarynet(ap_int<2>&data0, ap_int<2>data1[593]) {
    ap_int<2> data0_1[64];
    r_64_593(data0_1, data1);
    r_16_4(data0, data0_1);
}

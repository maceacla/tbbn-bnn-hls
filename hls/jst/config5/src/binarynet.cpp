#include "ap_axi_sdata.h"
#include "hls_stream.h"
#include "r_64_16.h"
#include "r_5_16_4.h"
#include "r_5n1.h"
#include "ap_int.h"

void binarynet(ap_int<16> &data0, ap_uint<1> data1[16]) {
  ap_uint<1> data0_1[64];
  r_64_16(data0_1, data1);
  ap_int<2> data0_2[5];
  r_5_16_4(data0_2, data0_1);
  r_5n1(data0, data0_2);
}

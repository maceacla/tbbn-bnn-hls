#ifndef Accelerator_H
#define Accelerator_H
#include "ap_axi_sdata.h"
#include "hls_stream.h"
void Accelerator(hls::stream<ap_axiu<32, 1, 1, 1>>& data_out, hls::stream<ap_axiu<128, 1, 1, 1>>& data_in);
#endif

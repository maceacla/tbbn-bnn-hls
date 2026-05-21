#include "r_16_4_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_16_4(ap_int<2>&data0, ap_int<2>data1[64]){
	#pragma HLS ARRAY_PARTITION complete variable=data0
	#pragma HLS ARRAY_PARTITION complete variable=data1
	#pragma HLS ARRAY_PARTITION complete variable=data2
	#pragma HLS ARRAY_PARTITION complete variable=data3
	#pragma HLS PIPELINE II=1
	ap_int<16>acc0=0;
	for (int lidx0=0; lidx0<16; lidx0++){
	   ap_int<16>val0=data1[((lidx0*4)+1)];
	   ap_int<16>val1=data1[((lidx0*4)+2)];
	   ap_int<16>val2=data1[((lidx0*4)+3)];
	   ap_int<16>val3=data1[(lidx0*4)];
	   acc0=(acc0+(((val3+val0)+val1)+val2));
	}
	ap_int<16>val4=data2[0];
	ap_int<16>val5=data3[0];
	data0=((((((acc0+(val4*-1)))<(0))) ? -1 : 1)*val5);
}

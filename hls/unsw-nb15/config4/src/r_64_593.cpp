#include "r_64_593_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_64_593(ap_int<2>data0[64], ap_int<2>data1[593]){
	#pragma HLS ARRAY_PARTITION complete variable=data0
	#pragma HLS ARRAY_PARTITION complete variable=data1
	#pragma HLS ARRAY_PARTITION complete variable=data2
	#pragma HLS ARRAY_PARTITION complete variable=data3
	#pragma HLS ARRAY_PARTITION complete variable=data4
	#pragma HLS PIPELINE II=1
	for (int lidx0=0; lidx0<64; lidx0++){
	   ap_int<16>acc0=0;
	   for (int lidx1=0; lidx1<593; lidx1++){
	      ap_int<16>val0=data1[lidx1];
	      ap_int<16>val1=data2[((lidx0*593)+lidx1)];
	      acc0=(acc0+(val0*val1));
	   }
	   ap_int<16>val2=data3[lidx0];
	   ap_int<16>val3=data4[lidx0];
	   data0[lidx0]=((((((acc0+(val2*-1)))<(0))) ? -1 : 1)*val3);
	}
}

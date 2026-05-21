#include "r_5_16_4_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_5_16_4(ap_int<2>data0[5], ap_uint<1>data1[64]){
	#pragma HLS ARRAY_PARTITION complete variable=data0
	#pragma HLS ARRAY_PARTITION complete variable=data1
	#pragma HLS ARRAY_PARTITION complete variable=data2
	#pragma HLS ARRAY_PARTITION complete variable=data3
	#pragma HLS ARRAY_PARTITION complete variable=data4
	#pragma HLS PIPELINE II=1
	for (int lidx0=0; lidx0<5; lidx0++){
	   ap_int<16>acc0=0;
	   for (int lidx1=0; lidx1<16; lidx1++){
	      ap_uint<1>val0=data1[((lidx1*4)+1)];
	      ap_uint<1>val1=data1[((lidx1*4)+2)];
	      ap_uint<1>val2=data1[((lidx1*4)+3)];
	      ap_uint<1>val3=data1[(lidx1*4)];
	      ap_uint<1>val4=data2[(((lidx0*64)+(lidx1*4))+1)];
	      ap_uint<1>val5=data2[(((lidx0*64)+(lidx1*4))+2)];
	      ap_uint<1>val6=data2[(((lidx0*64)+(lidx1*4))+3)];
	      ap_uint<1>val7=data2[((lidx0*64)+(lidx1*4))];
	      acc0=(acc0+(((((((val3)^(val7)))!=(1))+((((val0)^(val4)))!=(1)))+((((val1)^(val5)))!=(1)))+((((val2)^(val6)))!=(1))));
	   }
	   ap_int<16>val8=data3[lidx0];
	   ap_int<2>val9=(((((acc0+(val8*-1)))<(0))) ? -1 : 1);
	   data0[lidx0]=(val9*data4[lidx0]);
	}
}

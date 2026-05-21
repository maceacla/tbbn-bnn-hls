#include "r_128_32_4_b_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_128_32_4_b(ap_int<2>data0[128], ap_int<2>data1[128]){
	#pragma HLS ARRAY_PARTITION complete variable=data0
	#pragma HLS ARRAY_PARTITION complete variable=data1
	#pragma HLS ARRAY_PARTITION complete variable=data2
	#pragma HLS ARRAY_PARTITION complete variable=data3
	#pragma HLS ARRAY_PARTITION complete variable=data4
	#pragma HLS PIPELINE II=1
	for (int lidx0=0; lidx0<128; lidx0++){
	   ap_int<16>acc0=0;
	   for (int lidx1=0; lidx1<32; lidx1++){
	      ap_int<16>val0=data1[((lidx1*4)+1)];
	      ap_int<16>val1=data1[((lidx1*4)+2)];
	      ap_int<16>val2=data1[((lidx1*4)+3)];
	      ap_int<16>val3=data1[(lidx1*4)];
	      ap_int<16>val4=data2[(((lidx0*128)+(lidx1*4))+1)];
	      ap_int<16>val5=data2[(((lidx0*128)+(lidx1*4))+2)];
	      ap_int<16>val6=data2[(((lidx0*128)+(lidx1*4))+3)];
	      ap_int<16>val7=data2[((lidx0*128)+(lidx1*4))];
	      acc0=(acc0+((((val3*val7)+(val0*val4))+(val1*val5))+(val2*val6)));
	   }
	   float val8=data3[lidx0];
	   float val9=data4[lidx0];
	   float val10=data5[lidx0];
	   float val11=data6[lidx0];
	   data0[lidx0]=((((((((acc0+(val8*-1.0))*val9)*(sqrt((1/((val10+1e-05))))))+val11))<(0.0))) ? -1.0 : 1.0);
	}
}
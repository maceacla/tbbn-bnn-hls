#include "r_64_16_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_64_16(ap_int<2>data0[64], ap_int<2>data1[16]){
	#pragma HLS ARRAY_PARTITION complete variable=data0
	#pragma HLS ARRAY_PARTITION complete variable=data1
	#pragma HLS ARRAY_PARTITION complete variable=data2
	#pragma HLS ARRAY_PARTITION complete variable=data3
	#pragma HLS ARRAY_PARTITION complete variable=data4
	#pragma HLS ARRAY_PARTITION complete variable=data5
	#pragma HLS ARRAY_PARTITION complete variable=data6
	#pragma HLS PIPELINE II=1
	for (int lidx0=0; lidx0<64; lidx0++){
	   ap_int<16>val0=data1[0];
	   ap_int<16>val1=data1[1];
	   ap_int<16>val2=data1[2];
	   ap_int<16>val3=data1[3];
	   ap_int<16>val4=data1[4];
	   ap_int<16>val5=data1[5];
	   ap_int<16>val6=data1[6];
	   ap_int<16>val7=data1[7];
	   ap_int<16>val8=data1[8];
	   ap_int<16>val9=data1[9];
	   ap_int<16>val10=data1[10];
	   ap_int<16>val11=data1[11];
	   ap_int<16>val12=data1[12];
	   ap_int<16>val13=data1[13];
	   ap_int<16>val14=data1[14];
	   ap_int<16>val15=data1[15];
	   ap_int<16>val16=data2[((lidx0*16)+1)];
	   ap_int<16>val17=data2[((lidx0*16)+2)];
	   ap_int<16>val18=data2[((lidx0*16)+3)];
	   ap_int<16>val19=data2[((lidx0*16)+4)];
	   ap_int<16>val20=data2[((lidx0*16)+5)];
	   ap_int<16>val21=data2[((lidx0*16)+6)];
	   ap_int<16>val22=data2[((lidx0*16)+7)];
	   ap_int<16>val23=data2[((lidx0*16)+8)];
	   ap_int<16>val24=data2[((lidx0*16)+9)];
	   ap_int<16>val25=data2[((lidx0*16)+10)];
	   ap_int<16>val26=data2[((lidx0*16)+11)];
	   ap_int<16>val27=data2[((lidx0*16)+12)];
	   ap_int<16>val28=data2[((lidx0*16)+13)];
	   ap_int<16>val29=data2[((lidx0*16)+14)];
	   ap_int<16>val30=data2[((lidx0*16)+15)];
	   ap_int<16>val31=data2[(lidx0*16)];
	   float val32=data3[lidx0];
	   float val33=data4[lidx0];
	   float val34=data5[lidx0];
	   float val35=data6[lidx0];
	   data0[lidx0]=((((((((((((((((((((((((val0*val31)+(val1*val16))+(val2*val17))+(val3*val18))+(val4*val19))+(val5*val20))+(val6*val21))+(val7*val22))+(val8*val23))+(val9*val24))+(val10*val25))+(val11*val26))+(val12*val27))+(val13*val28))+(val14*val29))+(val15*val30))+(val32*-1.0))*val33)*(sqrt((1/((val34+1e-05))))))+val35))<(0.0))) ? -1.0 : 1.0);
	}
}
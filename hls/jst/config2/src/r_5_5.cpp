#include "r_5_5_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_5_5(ap_int<16>data0[5], ap_int<16>data1[5]){
	data0[4]=0;
	ap_int<16>val0=data1[0];
	ap_int<16>val1=data1[1];
	ap_int<16>val2=data1[2];
	ap_int<16>val3=data1[3];
	ap_int<16>val4=data2[0];
	data0[0]=(((((val0)!=(val4)))!=(1))*4);
	data0[1]=(((((val1)!=(val4)))!=(1))*3);
	data0[2]=(((((val2)!=(val4)))!=(1))*2);
	data0[3]=((((val3)!=(val4)))!=(1));
}
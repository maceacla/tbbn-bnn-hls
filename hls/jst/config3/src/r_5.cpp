#include "ap_int.h"
#include "ap_float.h"
void r_5(ap_int<16>data0, ap_int<16>data1[5]){
	ap_int<16>val0=data1[0];
	ap_int<16>val1=data1[1];
	ap_int<16>alu0=((val0>val1) ? val0 : val1);
	ap_int<16>val2=data1[2];
	ap_int<16>alu1=((alu0>val2) ? alu0 : val2);
	ap_int<16>val3=data1[3];
	ap_int<16>alu2=((alu1>val3) ? alu1 : val3);
	ap_int<16>val4=data1[4];
	ap_int<16>alu3=((alu2>val4) ? alu2 : val4);
	data0=alu3;
}
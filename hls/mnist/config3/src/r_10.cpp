#include "ap_int.h"
#include "ap_float.h"
void r_10(ap_int<16>data0, ap_int<16>data1[10]){
	ap_int<16>val0=data1[0];
	ap_int<16>val1=data1[1];
	ap_int<16>alu0=((val0>val1) ? val0 : val1);
	ap_int<16>val2=data1[2];
	ap_int<16>alu1=((alu0>val2) ? alu0 : val2);
	ap_int<16>val3=data1[3];
	ap_int<16>alu2=((alu1>val3) ? alu1 : val3);
	ap_int<16>val4=data1[4];
	ap_int<16>alu3=((alu2>val4) ? alu2 : val4);
	ap_int<16>val5=data1[5];
	ap_int<16>alu4=((alu3>val5) ? alu3 : val5);
	ap_int<16>val6=data1[6];
	ap_int<16>alu5=((alu4>val6) ? alu4 : val6);
	ap_int<16>val7=data1[7];
	ap_int<16>alu6=((alu5>val7) ? alu5 : val7);
	ap_int<16>val8=data1[8];
	ap_int<16>alu7=((alu6>val8) ? alu6 : val8);
	ap_int<16>val9=data1[9];
	ap_int<16>alu8=((alu7>val9) ? alu7 : val9);
	data0=alu8;
}
#include "r_10_10_params.h"
#include "ap_int.h"
#include "ap_float.h"
void r_10_10(ap_int<16>data0[10], ap_int<16>data1[10]){
	for (int lidx0=0; lidx0<10; lidx0++){
	   #pragma HLS UNROLL factor=1
	   ap_int<16>val0=data1[lidx0];
	   ap_int<16>val1=data2[0];
	   data0[lidx0]=(((((val0)!=(val1)))!=(1))*(((((((((((((((lidx0)<(9)))!=(1))) ? -1 : 0)+((((((lidx0)<(8)))!=(1))) ? -1 : 0))+((((((lidx0)<(7)))!=(1))) ? -1 : 0))+((((((lidx0)<(6)))!=(1))) ? -1 : 0))+((((((lidx0)<(5)))!=(1))) ? -1 : 0))+((((((lidx0)<(4)))!=(1))) ? -1 : 0))+((((((lidx0)<(3)))!=(1))) ? -1 : 0))+((((((lidx0)<(2)))!=(1))) ? -1 : 0))+((((((lidx0)<(1)))!=(1))) ? -1 : 0))+9));
	}
}
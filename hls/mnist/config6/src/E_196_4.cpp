#include "ap_int.h"
#include "ap_float.h"
void E_196_4(ap_uint<1>data0[784], ap_uint<1>data1[784]){
	for (int lidx0=0; lidx0<196; lidx0++){
	   #pragma HLS UNROLL factor=1
	   ap_uint<1>val0=data1[((lidx0*4)+1)];
	   data0[((lidx0*4)+1)]=((0)<(val0));
	   ap_uint<1>val1=data1[((lidx0*4)+2)];
	   data0[((lidx0*4)+2)]=((0)<(val1));
	   ap_uint<1>val2=data1[((lidx0*4)+3)];
	   data0[((lidx0*4)+3)]=((0)<(val2));
	   ap_uint<1>val3=data1[(lidx0*4)];
	   data0[(lidx0*4)]=((0)<(val3));
	}
}
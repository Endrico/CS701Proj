#ifndef __Mul7_h_
#define __Mul7_h_

#include "systemc.h"

SC_MODULE(Mul7)
{
  sc_in<sc_uint<3> > select;
  sc_in<sc_uint<16> > in1;
  sc_in<sc_uint<16> > in2;
  sc_in<sc_uint<16> > in3;
  sc_in<sc_uint<16> > in4;
  sc_in<sc_uint<16> > in5;
  sc_in<sc_uint<16> > in6;
  sc_in<sc_uint<16> > in7;
  sc_out<sc_uint<16> > out;

  void my_Mul7( );

  SC_CTOR(Mul7)
  {
    SC_METHOD(my_Mul7);
    sensitive << select << in1 << in2 << in3 << in4 << in5 << in6 << in7;
  }
};

#endif // __Mul7_h_



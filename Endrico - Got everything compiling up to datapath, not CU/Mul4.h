#ifndef __Mul4_h_
#define __Mul4_h_

#include "systemc.h"

SC_MODULE(Mul4)
{
  sc_in<sc_uint<2> > select;
  sc_in<sc_uint<16> > in1;
  sc_in<sc_uint<16> > in2;
  sc_in<sc_uint<16> > in3;
  sc_in<sc_uint<16> > in4;
  sc_out<sc_uint<16> > out;

  void my_mul4( );

  SC_CTOR(Mul4)
  {
    SC_METHOD(my_mul4);
    sensitive << select << in1 << in2 << in3 << in4;
  }
};

#endif // __Mul4_h_

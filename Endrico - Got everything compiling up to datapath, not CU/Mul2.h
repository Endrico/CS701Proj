#ifndef __Mul2_h_
#define __Mul2_h_

#include "systemc.h"

SC_MODULE(Mul2)
{
  sc_in<bool> select;
  sc_in<sc_uint<16> > in1;
  sc_in<sc_uint<16> > in2;
  sc_out<sc_uint<16> > out;

  void my_mul2( );

  SC_CTOR(Mul2)
  {
    SC_METHOD(my_mul2);
    sensitive << select << in1 << in2;
  }
};

#endif // __Mul2_h_

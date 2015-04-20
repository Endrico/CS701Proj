#ifndef __Mul4_h_
#define __Mul4_h_

#include "systemc.h"

template<int SIZE>
SC_MODULE(Mul4)
{
  sc_in<sc_uint<2> > select;
  sc_in<sc_uint<SIZE> > in1;
  sc_in<sc_uint<SIZE> > in2;
  sc_in<sc_uint<SIZE> > in3;
  sc_in<sc_uint<SIZE> > in4;
  sc_out<sc_uint<SIZE> > out;

  void my_mul4( );

  SC_CTOR(Mul4)
  {
    SC_METHOD(my_mul4);
    sensitive << select << in1 << in2 << in3 << in4;
  }
};

#endif // __Mul4_h_

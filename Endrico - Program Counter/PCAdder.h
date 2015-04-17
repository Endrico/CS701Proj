#ifndef __PCAdder_h_
#define __PCAdder_h_

#include "systemc.h"

SC_MODULE(PCAdder)
{
  sc_in<bool> PCAdder_op;
  sc_in<sc_int<16> > A;
  sc_in<sc_int<16> > B;
  sc_out<sc_int<16> > out;

  void my_PCAdder( );

  SC_CTOR(PCAdder)
  {
    SC_METHOD(my_PCAdder);
    sensitive << A << B << PCAdder_op;
  }
};

#endif // __PCAdder_h_

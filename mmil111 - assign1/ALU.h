#ifndef __ALU_h_
#define __ALU_h_

#include "systemc.h"

SC_MODULE(ALU)
{
  sc_in<bool> alu_op;
  sc_in<sc_int<16> > A;
  sc_in<sc_int<16> > B;
  sc_out<sc_int<16> > out;

  void my_ALU( );

  SC_CTOR(ALU)
  {
    SC_METHOD(my_ALU);
    sensitive << A << B << alu_op;
  }
};

#endif // __ALU_h_

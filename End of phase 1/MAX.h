#ifndef __MAX_h_
#define __MAX_h_

#include "systemc.h"

SC_MODULE(MAX)
{
  sc_in<sc_uint<16> > A;
  sc_in<sc_uint<16> > B;
  sc_out<sc_uint<16> > out;

  void my_MAX( );

  SC_CTOR(MAX)
  {
    SC_METHOD(my_MAX);
    sensitive << A << B;
  }
};

#endif // __MAX_h_


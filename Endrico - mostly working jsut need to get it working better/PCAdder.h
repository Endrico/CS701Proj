// PCAdder.h

#ifndef __PCAdder_h_
#define __PCAdder_h_

#include "systemc.h"

SC_MODULE(PCAdder)
{
  //Port
  sc_in<sc_uint<16> > Input;
  
  sc_out<sc_uint<16> > Output;
  
  void my_PCAdder( );

  SC_CTOR(PCAdder)
  {
    SC_METHOD(my_PCAdder);
    sensitive << Input;
  }
};

#endif // __PCAdder_h_

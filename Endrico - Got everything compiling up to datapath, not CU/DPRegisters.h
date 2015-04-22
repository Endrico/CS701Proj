// DPRegisters.h

#ifndef __DPRegisters_h_
#define __DPRegisters_h_

#include "systemc.h"

SC_MODULE(DPRegisters)
{
  //Port
  sc_in<bool> CLK;
  sc_in<bool> RST;
  sc_in<bool> Ld_Reg;
  sc_in<sc_uint<16> > Input;
  
  sc_out<sc_uint<16> > Output;
  
  // Variables
  sc_uint<32> Reg_temp;
  
  void my_DPRegisters( );

  SC_CTOR(DPRegisters)
  {
    SC_METHOD(my_DPRegisters);
    sensitive << CLK.pos();
  }
};

#endif // __DPRegisters_h_

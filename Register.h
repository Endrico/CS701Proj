// Register.h

#ifndef __Register_h_
#define __Register_h_

#include "systemc.h"

SC_MODULE(Register)
{
  //Port
  sc_in<bool> CLK;
  sc_in<bool> RST;
  sc_in<bool> Ld_Reg;
  sc_in<sc_uint<16> > Input;
  
  sc_out<sc_uint<16> > Output;
  
  // Variables
  sc_uint<16> Reg_temp;
  
  void my_Register( );

  SC_CTOR(Register)
  {
    SC_METHOD(my_Register);
    sensitive << CLK.pos();
  }
};

#endif // __Register_h_


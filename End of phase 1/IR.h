#ifndef __IR_h_
#define __IR_h_

#include "systemc.h"

SC_MODULE(IR)
{
  sc_in<bool> CLK;
  sc_in<bool> RST;
  sc_in<bool> ld_IR;
  sc_in<sc_uint<16> > I_in;
  sc_out<sc_uint<32> > IReg;
  sc_uint<16> IReg_temp_top, IReg_temp_bot;

  bool ld_top;

  void my_IR( );

  SC_CTOR(IR)
  {
	ld_top = 0;
	IReg_temp_top = 0;
	IReg_temp_bot = 0;
    SC_METHOD(my_IR);
    sensitive << ld_IR << RST; // took out the .pos()
  }
};

#endif // __IR_h_

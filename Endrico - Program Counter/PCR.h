#ifndef __PCR_h_
#define __PCR_h_

#include "systemc.h"

SC_MODULE(PCR)
{
  sc_in<bool> CLK;
  sc_in<bool> ld_PCR;
  sc_in<sc_uint<16> > I_addr_in;
  sc_out<sc_uint<32> > PCReg;

  bool ld_top;

  void my_PCR( );

  SC_CTOR(PCR)
  {
	ld_top = 0;
	PCReg_temp_top = 0;
	PCReg_temp_bot = 0;
    SC_METHOD(my_PCR);
    sensitive << CLK.pos();
  }
};

#endif // __PCR_h_

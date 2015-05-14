//PC.h

#ifndef __processor_h_
#define __processor_h_

#include "systemc.h"
#include "IR.h"



SC_MODULE(processor)
{
  // Ports
  sc_in<bool> CLK;
  sc_in<sc_uint<16> > Operand;
  sc_in<sc_uint<16> > Rx;
  sc_in<sc_uint<16> > Data_out;
  
  sc_out<sc_uint<16> > IR_out;
  sc_out<sc_int<16> > PC_out;

  // Signals
  sc_signal<sc_uint<16> > PC1;
  sc_signal<sc_uint<16> > PCMux_out;
  sc_signal<bool> PCR_ld;
  
  // Instantiating Modules
  Register *my_Register;

  SC_CTOR(processor)
  {
    my_PCR = new Register("my_Register");
    my_PCR->CLK(CLK);
    my_PCR->Ld_Reg(PCR_ld);
    my_PCR->Input(PCMux_out);
    my_PCR->Output(PC_out);

    sensitive << CLK;
  }
};

#endif // __processor_h_

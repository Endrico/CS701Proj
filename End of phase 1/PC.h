//PC.h

#ifndef __PC_h_
#define __PC_h_

#include "systemc.h"
#include "PCAdder.h"
#include "Register.h"
#include "Mul4.h"

SC_MODULE(PC)
{
  // Ports
  sc_in<bool> CLK;
  sc_in<bool> RST;
  sc_in<sc_uint<2> > PC_mux_in;
  sc_in<sc_uint<16> > Operand;
  sc_in<sc_uint<16> > Rx;
  sc_in<sc_uint<16> > Data_out;
  sc_in<bool> PC_reg_ld;

  sc_out<sc_uint<16> > Prog_mem_out;

  // Signals
  sc_signal<sc_uint<16> > PC1;
  sc_signal<sc_uint<16> > PCMux_out;

  sc_signal<sc_uint<16> > t_I;
  sc_signal<sc_int<16> > t_D;
  sc_signal<sc_lv<16> > t_Ilv;
  sc_signal<sc_lv<16> > t_Dlv;
  sc_signal<sc_logic> t_wren;
  sc_signal<sc_lv<16> > t_rd_mem, t_wr_mem;

  // Instantiating Modules
  // Program Counter Block
  Register *my_PCR;
  Mul4 *my_PCMul;
  PCAdder *my_PCAdder;  

  SC_CTOR(PC)
  {
    // Program Counter Register
    my_PCR = new Register("my_PCR");
    my_PCR->CLK(CLK);
    my_PCR->RST(RST);
    my_PCR->Ld_Reg(PC_reg_ld);
    my_PCR->Input(PCMux_out);
    my_PCR->Output(Prog_mem_out);

    // Program Counter Multiplexer
    my_PCMul = new Mul4("my_PCMul");
    //Input
    my_PCMul->select(PC_mux_in);
    my_PCMul->in1(PC1);
    my_PCMul->in2(Operand);
    my_PCMul->in3(Rx);
    my_PCMul->in4(Data_out);
    // Output
    my_PCMul->out(PCMux_out);

    // Program Counter
    my_PCAdder = new PCAdder("my_PCAdder");
    my_PCAdder->Input(Prog_mem_out);
    my_PCAdder->Output(PC1);
  }
};

#endif // __PC_h_

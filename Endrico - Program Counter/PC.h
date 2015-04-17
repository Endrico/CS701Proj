#ifndef __PC_h_
#define __PC_h_

#include "systemc.h"
#include "PCAdder.h"
#include "PCR.h"
#include "Mul4.h"
//#include "RF.h"

SC_MODULE(PC)
{
  sc_in<bool> CLK;
  sc_in<bool> reset;
  sc_in<bool> run;
  sc_in<sc_uint<16> > I_in;
  sc_in<sc_int<16> > D_in;
  sc_out<bool> done;

  sc_signal<bool> ld_PCR;
  sc_signal<bool> sel_A;
  sc_signal<bool> sel_B;
  sc_signal<bool> PCAdder_op;
  sc_signal<bool> wr_en;

  sc_signal<sc_bv<2> > sel_C;
  sc_signal<sc_bv<4> > sel_X;
  sc_signal<sc_bv<4> > sel_Z;
  sc_signal<sc_bv<4> > wr_dest;

  sc_signal<sc_uint<32> > PCRsig;
  sc_signal<sc_int<16> > Xsig;
  sc_signal<sc_int<16> > Zsig;
  sc_signal<sc_int<16> > Asig;
  sc_signal<sc_int<16> > Bsig;
  sc_signal<sc_int<16> > PCAdder_out;
  sc_signal<sc_int<16> > wr_data;

  sc_signal<sc_bv<16> > I_line;
  sc_signal<sc_int<16> > Operand_line;
  
  sc_bv<16> I_line_temp;
  sc_int<16> Op_line_temp;

  PCR *my_PCR;
  ControlUnit *my_CU;
  RF *my_RF;
  PCAdder *my_PCAdder;
  Mul4 *C_sel;

  SC_CTOR(PC)
  {
    my_PCR = new PCR("my_PCR");
    my_PCR->CLK(CLK);
    my_PCR->ld_PCR(ld_PCR);
    my_PCR->I_in(I_in);
    my_PCR->PCReg(PCRsig);

    my_PCAdder = new PCAdder("my_PCAdder");
    my_PCAdder->PCAdder_op(PCAdder_op);
    my_PCAdder->A(Asig);
    my_PCAdder->B(Bsig);
    my_PCAdder->out(PCAdder_out);

    C_sel = new Mul4("C_sel");
    C_sel->select(sel_C);
    C_sel->in1(D_in);
    C_sel->in2(Operand_line);
    C_sel->in3(PCAdder_out);
    C_sel->out(wr_data);

    sensitive << PCRsig;
  }
};

#endif // __PC_h_

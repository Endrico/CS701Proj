#ifndef __processor_h_
#define __processor_h_

#include "systemc.h"
#include "ALU.h"
#include "ControlUnit.h"
#include "IR.h"
#include "Mul2.h"
#include "Mul4.h"
#include "RF.h"

SC_MODULE(processor)
{
  sc_in<bool> CLK;
  sc_in<bool> reset;
  sc_in<bool> run;
  sc_in<sc_uint<16> > I_in;
  sc_in<sc_int<16> > D_in;
  sc_out<bool> done;

  sc_signal<bool> ld_IR;
  sc_signal<bool> sel_A;
  sc_signal<bool> sel_B;
  sc_signal<bool> alu_op;
  sc_signal<bool> wr_en;

  sc_signal<sc_bv<2> > sel_C;
  sc_signal<sc_bv<4> > sel_X;
  sc_signal<sc_bv<4> > sel_Z;
  sc_signal<sc_bv<4> > wr_dest;

  sc_signal<sc_uint<32> > IRsig;
  sc_signal<sc_int<16> > Xsig;
  sc_signal<sc_int<16> > Zsig;
  sc_signal<sc_int<16> > Asig;
  sc_signal<sc_int<16> > Bsig;
  sc_signal<sc_int<16> > ALU_out;
  sc_signal<sc_int<16> > wr_data;

  sc_signal<sc_bv<16> > I_line;
  sc_signal<sc_int<16> > Operand_line;
  
  sc_bv<16> I_line_temp;
  sc_int<16> Op_line_temp;

  void wiresplitter() {
	I_line_temp = IRsig.read()(31,16);
	Op_line_temp = IRsig.read()(15,0);
    I_line = I_line_temp;
    Operand_line = Op_line_temp;
  }


  IR *my_IR;
  ControlUnit *my_CU;
  RF *my_RF;
  ALU *my_ALU;
  Mul2 *A_sel;
  Mul2 *B_sel;
  Mul4 *C_sel;

  SC_CTOR(processor)
  {
    my_IR = new IR("my_IR");
    my_IR->CLK(CLK);
    my_IR->ld_IR(ld_IR);
    my_IR->I_in(I_in);
    my_IR->IReg(IRsig);

    my_CU = new ControlUnit("my_CU");

    my_CU->run(run);
    my_CU->reset(reset);
    my_CU->CLK(CLK);
    my_CU->IR_op(I_line);
    my_CU->done(done);
    my_CU->ld_IR(ld_IR);

    my_CU->sel_X(sel_X);
    my_CU->sel_Z(sel_Z);
    my_CU->wr_en(wr_en);
    my_CU->wr_dest(wr_dest);

    my_CU->sel_A(sel_A);
    my_CU->sel_B(sel_B);
    my_CU->sel_C(sel_C);
    my_CU->alu_op(alu_op);

    my_RF = new RF("my_RF");
    my_RF->CLK(CLK);
    my_RF->sel_x(sel_X);
    my_RF->sel_z(sel_Z);
    my_RF->wr_en(wr_en);
    my_RF->wr_dest(wr_dest);
    my_RF->wr_data(wr_data);
    my_RF->X(Xsig);
    my_RF->Z(Zsig);

    my_ALU = new ALU("my_ALU");
    my_ALU->alu_op(alu_op);
    my_ALU->A(Asig);
    my_ALU->B(Bsig);
    my_ALU->out(ALU_out);

    A_sel = new Mul2("A_sel");
    A_sel->select(sel_A);
    A_sel->in1(Xsig);
    A_sel->in2(Zsig);
    A_sel->out(Asig);

    B_sel = new Mul2("B_sel");
    B_sel->select(sel_B);
    B_sel->in1(Zsig);
    B_sel->in2(Operand_line);
    B_sel->out(Bsig);

    C_sel = new Mul4("C_sel");
    C_sel->select(sel_C);
    C_sel->in1(D_in);
    C_sel->in2(Operand_line);
    C_sel->in3(ALU_out);
    C_sel->out(wr_data);

    SC_METHOD(wiresplitter);
    sensitive << IRsig;
  }
};

#endif // __processor_h_

#ifndef __processor_h_
#define __processor_h_

#include "systemc.h"
#include "ControlUnit.h"
#include "Datapath.h"

SC_MODULE(processor)
{
// Ports
  // Inputs
  sc_in<bool> CLK;
  sc_in<bool> RST_L;
  sc_in<sc_uint<2> > DPRR;
  sc_in<bool> ER;
  sc_in<sc_uint<16> > SIPi;
  sc_in<sc_uint<16> > M_OUT;
  sc_in<sc_uint<16> > SOPi;
  sc_in<sc_uint<16> > SVOPi;
  sc_in<sc_uint<16> > DATA;
  sc_in<sc_uint<13> > ADDR;
  // Outputs
  sc_out<bool> WE;
  sc_out<bool> CLR_IRQ;
  sc_out<bool> EOT;
  sc_out<bool> DPC;
  sc_out<sc_uint<12> > DPCR_CCD;
  sc_out<sc_uint<4> > CCD;
  sc_out<sc_uint<4> > PCD;
  
// Signals
  sc_signal<

  Datapath *my_Datapath;
  ControlUnit *my_CU;
  Mul2 *dpcr; Mul2 *addr;

  SC_CTOR(processor)
  {
	// Control Unit
    my_CU = new ControlUnit("my_CU");
	// Inputs
    my_CU->CLK(CLK);
    my_CU->RST_L(RST_L);
	// Instruction Code #TODO
    my_CU->(I_line);
	// Outputs
    my_CU->WE(sel_X);
    my_CU->mem_sel(sel_Z);
	// Control Signals #TODO
    my_CU->wr_en(wr_en);
    my_CU->wr_dest(wr_dest);
    my_CU->sel_A(sel_A);
    my_CU->sel_B(sel_B);
    my_CU->sel_C(sel_C);
    my_CU->alu_op(alu_op);
	
	// Datapath #TODO
	my_Datapath = new Datapath("my_Datapath");
	// Inputs
	my_Datapath->DPRR();
	my_Datapath->ER();
	my_Datapath->SIP();
	my_Datapath->M_OUT();
	// Control Signals
	my_Datapath->
	my_Datapath->
	my_Datapath->
	my_Datapath->
	// Outputs
	my_Datapath->CLR_IRQ();
	my_Datapath->EOT();
	my_Datapath->DPC();
	my_Datapath->DPCR_CCD();
	my_Datapath->CCD();
	my_Datapath->PCD();
	my_Datapath->SOP();
	my_Datapath->SVOP();
	my_Datapath->DATA();
	my_Datapath->ADDR();
	// Instruction Code #TODO
	my_Datapath->OP();
	my_Datapath->AM();
	my_Datapath->RX();
	my_Datapath->RZ();
	my_Datapath->OPERAND();
	
	// DPCR Multiplexer
	dpcr = new Mul2("dpcr");
	// Inputs
	dpcr->select();
	dpcr->in1();
	dpcr->in2();
	// Output
	dpcr->out();
	
	// ADDR Multiplexer
	addr = new Mul2("addr");
	// Inputs
	addr->select();
	addr->in1();
	addr->in2();
	//Output
	addr->out();
  
  }
};

#endif // __Processor_h_

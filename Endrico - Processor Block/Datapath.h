#ifndef __DATAPATH_H_
#define __DATAPATH_H_

#include "systemc.h"
#include "ALU.h"
#include "IR.h"
#include "RF.h"
#include "PC.h"
#include "DPRR.h"
#include "DPCR.h"
#include "Data_mem.h"
#include "Register.h"
#include "DFF.h"

SC_MODULE(datapath)
{
  sc_in<bool> CLK;
  sc_in<bool> RST;
  sc_in<bool> ld_IR;

  sc_out<bool> CLR_IRQ;
  sc_out<bool> EOT;
  sc_out<bool> DPC;
  sc_out<sc_uint<8> > DPCR;
  sc_out<sc_uint<4> > CCD;
  sc_out<sc_uint<4> > PCD;
  sc_out<sc_uint<16> > SOPi;
  sc_out<sc_uint<16> > SIPi;
  sc_out<sc_uint<16> > SVOPi;
  sc_out<sc_uint<16> > DATA;
  sc_out<sc_uint<12> > ADDR;

  ALU *my_ALU;
  IR *my_IR;
  RF *my_RF;
  PC *my_PC;
  DPRR *my_DPRR;
  DPCR *my_DPCR;
  Data_mem *my_Data_mem;
  Register *SIP, *SOP, *SVOP;
  ER *my_ER;
  EOT *my_EOT;
  Mul4 *A_sel;
  Mul2 *B_sel;
  Mul4 *DCPR_sel;

  SC_CTOR(datapath)
  {
    my_ALU = new ALU("my_ALU");
    my_ALU->clrz();
    my_ALU->alu_op();
    my_ALU->A();
    my_ALU->B();
    my_ALU->out();
    my_ALU->Z();

    my_IR = new IR("my_IR");
    my_IR->CLK(CLK);
    my_IR->RST(RST);
    my_IR->ld_IR(ld_IR);
    my_IR->I_in();

    my_IR->IReg();

    my_RF = new RF("my_RF");
    my_RF->RST();
    my_RF->CLK(CLK);
    my_RF->sel_x();
    my_RF->sel_z();

    my_RF->wr_en();
    my_RF->wr_dest();
    my_RF->wr_data();

    my_RF->X();
    my_RF->Z();
    my_RF->ccd(CCD);
    my_RF->pcd(PCD);

    my_PC = new PC("my_PC");
    my_PC->CLK(CLK);
    my_PC->RST(RST);
    my_PC->PC_mux_in();
    my_PC->Operand();
    my_PC->Rx();
    my_PC->Data_out();
    my_PC->PC_reg_ld();

    SIP = new Register("SIP");
    SIP->CLK(CLK);
    SIP->RST(RST);
    SIP->Ld_Reg();
    SIP->Input();
    SIP->Output(SIPi);

    SOP = new Register("SOP");
    SOP->CLK(CLK);
    SOP->RST(RST);
    SOP->Ld_Reg();
    SOP->Input();
    SOP->Output(SOPi);

    SVOP = new Register("SVOP");
    SVOP->CLK(CLK);
    SVOP->RST(RST);
    SVOP->Ld_Reg();
    SVOP->Input();
  
    SVOP->Output(SVOPi);

  }
};

#endif // __DATAPATH_H_

// ControlUnit.h

#ifndef __ControlUnit_h_
#define __ControlUnit_h_

#include "systemc.h"

SC_MODULE(ControlUnit)
{
  sc_in<bool> CLK;
  sc_in<bool> RST_L;
  //sc_in<bool> nios_control;
  sc_in<bool> debug_hold;
  sc_in<bool> start_hold;
  sc_in<sc_uint<16> > I_code;
  sc_out<bool> mem_sel;
  sc_out<bool> WE;

  sc_in<bool> zout;
  sc_out<bool> ld_IR;
  sc_out<bool> clrz;
  sc_out<bool> clrer;
  sc_out<bool> clreot;
  sc_out<bool> seteot;
  sc_out<bool> wr_en;
  sc_out<bool> ER_Ld_Reg;
  sc_out<bool> SIP_Ld_Reg;
  sc_out<bool> SOP_Ld_Reg;
  sc_out<bool> SVOP_Ld_Reg;
  sc_out<bool> mux_B_sel;
  sc_out<bool> PC_reg_ld;
  sc_out<bool> data_write;
  sc_out<bool> mux_DMR_sel;
  sc_out<bool> mux_DMW_sel;
  sc_out<sc_uint<2> > alu_op;
  sc_out<sc_uint<2> > mux_A_sel;
  sc_out<sc_uint<2> > mux_PC_sel;
  sc_out<sc_uint<3> > mux_RF_sel;
  sc_out<sc_uint<2> > mux_DM_Data_sel;
  sc_out<sc_uint<4> > sel_x;
  sc_out<sc_uint<4> > sel_z;
  sc_out<sc_uint<4> > wr_dest;

  sc_uint<2> AM;
  sc_uint<6> Opcode;
  sc_uint<4> Rx;
  sc_uint<4> Rz;

  typedef enum PD_State {
    Init,
    E0,
    E1,
    E1bis,
    E2,
    T0,
    T1,
    T2,
    T3
  };
  sc_signal<PD_State> state;
  
  PD_State Test; 
  bool DPC; 
  bool IRQ;
  bool ld_dprr_done; 
  bool CLR_IRQ; 

  void Pulse_Distributor();
  void Operation_Decoder();

  SC_CTOR(ControlUnit)
  {
	DPC = 1;
	IRQ = 0;
    state.write(Init);
    SC_METHOD(Pulse_Distributor);
    sensitive << CLK << RST_L;
    SC_METHOD(Operation_Decoder);
    sensitive << state;
	}
};

#endif // __ControlUnit_h_

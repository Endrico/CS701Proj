#ifndef __processor_h_
#define __processor_h_

#include "systemc.h"
#include "ControlUnit.h"
#include "Datapath.h"

SC_MODULE(processor)
{
  sc_in<bool> CLK;
  sc_in<bool> RST_L;
  sc_in<sc_uint<2> > DPRR;
  //sc_in<bool> ER;
  sc_in<sc_uint<16> > SIPi;
  sc_in<sc_uint<16> > M_OUT;

  sc_out<bool> WE;
  sc_out<bool> CLR_IRQ;
  sc_out<bool> EOT;
  sc_out<bool> DPC;
  sc_out<sc_uint<16> > DPCR_CCD; // This will be 12 plus the 4 from CCD
  sc_out<sc_uint<16> > CCD;
  sc_out<sc_uint<16> > PCD;
  sc_out<sc_uint<16> > SOPi;
  sc_out<sc_uint<16> > SVOPi;
  sc_out<sc_uint<16> > DATA;
  sc_out<sc_uint<12> > ADDR;
  
  // signals of control unit and data path
  sc_signal<bool> zout_sig;
  sc_signal<bool> ld_IR_sig;
  sc_signal<bool> clrz_sig;
  sc_signal<bool> clrer_sig; //TODO Assign // DONE 
  sc_signal<bool> clreot_sig; //TODO Assign // DONE
  sc_signal<bool> seteot_sig; //TODO Assign //DONE
  sc_signal<bool> wr_en_sig;
  sc_signal<bool> SIP_Ld_Reg_sig;
  sc_signal<bool> SOP_Ld_Reg_sig;
  sc_signal<bool> SVOP_Ld_Reg_sig;
  sc_signal<bool> DPCR_Ld_Reg;//??
  sc_signal<bool> mux_B_sel_sig;
  sc_signal<bool> PC_reg_ld_sig;
  sc_signal<bool> data_write_sig;
  sc_signal<bool> mux_DMR_sel_sig;
  sc_signal<bool> mux_DMW_sel;
  sc_signal<sc_uint<2> > alu_op_sig;
  sc_signal<sc_uint<2> > mux_A_sel_sig;
  sc_signal<sc_uint<2> > mux_PC_sel_sig;
  sc_signal<sc_uint<3> > mux_RF_sel_sig;
  sc_signal<sc_uint<2> > mux_DM_Data_sel_sig;
  sc_signal<sc_uint<4> > sel_x_sig;
  sc_signal<sc_uint<4> > sel_z_sig;
  sc_signal<sc_uint<4> > wr_dest_sig;
  
  //Debug Hold
  sc_signal<bool> debug_hold_sig;
  sc_signal<bool> start_hold_sig;
  sc_signal<sc_uint<2> >DPCR_sel;

  /* sc_signal<bool> CLR_IRQ;
  sc_signal<bool> EOT;
  sc_signal<bool> DPC; */
  
  sc_signal<bool> ER_Ld_Reg; //TODO Assign // DONE
 // sc_signal<sc_uint<32> > DPCR_sig; // Changed this nee to check
  /*sc_signal<sc_uint<4> > CCD;
  sc_signal<sc_uint<4> > PCD;
  sc_signal<sc_uint<16> > SOPi;
  sc_signal<sc_uint<16> > SVOPi;
  sc_signal<sc_uint<16> > DATA;
  sc_signal<sc_uint<12> > ADDR;*/

  sc_signal<sc_uint<16> > instruction_sig;
  
  // instanciating the components
  datapath *my_datapath;
  ControlUnit *my_controlunit;
  
   SC_CTOR(processor)
  {
	
	debug_hold_sig = 0;
	start_hold_sig = 1;
	DPCR_sel = 0;
  
  	my_datapath = new datapath("my_datapath");
	my_datapath->CLK(CLK); 
	my_datapath->RST(RST_L);
	my_datapath->SIPi(SIPi);
	// Control Signals
	my_datapath->zout(zout_sig);
	my_datapath->ld_IR(ld_IR_sig);
	my_datapath->clrz(clrz_sig);
    my_datapath->clrer(clrer_sig); //TODO Assign // DONE 
    my_datapath->clreot(clreot_sig); //TODO Assign // DONE
    my_datapath->seteot(seteot_sig); //TODO Assign //DONE
    my_datapath->wr_en(wr_en_sig);
    my_datapath->SIP_Ld_Reg(SIP_Ld_Reg_sig);
    my_datapath->SOP_Ld_Reg(SOP_Ld_Reg_sig);
    my_datapath->SVOP_Ld_Reg(SVOP_Ld_Reg_sig);
    my_datapath->DPCR_Ld_Reg(debug_hold_sig);
    my_datapath->mux_B_sel(mux_B_sel_sig);
    my_datapath->PC_reg_ld(PC_reg_ld_sig);
    my_datapath->data_write(data_write_sig);
    my_datapath->mux_DMR_sel(mux_DMR_sel_sig);
    my_datapath->mux_DMW_sel(mux_DMW_sel);
    my_datapath->alu_op(alu_op_sig);
    my_datapath->mux_A_sel(mux_A_sel_sig);
    my_datapath->mux_PC_sel(mux_PC_sel_sig);
    my_datapath->mux_RF_sel(mux_RF_sel_sig);
    my_datapath->mux_DM_Data_sel(mux_DM_Data_sel_sig);
	my_datapath->mux_DPCR_sel(DPCR_sel);
    my_datapath->sel_x(sel_x_sig);
    my_datapath->sel_z(sel_z_sig);
    my_datapath->wr_dest(wr_dest_sig);
    // ENV out
    my_datapath->CLR_IRQ(CLR_IRQ);
    my_datapath->EOTO(EOT);
    my_datapath->DPC(DPC);
    my_datapath->ER_Ld_Reg(ER_Ld_Reg); //TODO Assign // DONE
    my_datapath->DPCR(DPCR_CCD); // When we include the combining block this will output to that
    my_datapath->CCD(CCD);
    my_datapath->PCD(PCD);
    my_datapath->SOPi(SOPi);
    my_datapath->SVOPi(SVOPi);
    my_datapath->DATA(DATA);
    my_datapath->ADDR(ADDR);
    // Instruction code
    my_datapath->instruction(instruction_sig);
  
  
  
  // control unit
	my_controlunit = new ControlUnit("my_controlunit");
	my_controlunit->CLK(CLK);
	my_controlunit->RST_L(RST_L);
	//my_controlunit->nios_control(); // wtf is this?
	my_controlunit->debug_hold(debug_hold_sig);
	my_controlunit->start_hold(start_hold_sig);
	my_controlunit->I_code(instruction_sig);
	my_controlunit->mem_sel(debug_hold_sig);
	my_controlunit->WE(debug_hold_sig);

	my_controlunit->zout(zout_sig);
	my_controlunit->ld_IR(ld_IR_sig);
	my_controlunit->clrz(clrz_sig);
	my_controlunit->clrer(clrer_sig);
	my_controlunit->clreot(clreot_sig);
	my_controlunit->seteot(seteot_sig);
	my_controlunit->wr_en(wr_en_sig);
	my_controlunit->ER_Ld_Reg(ER_Ld_Reg);//
	my_controlunit->SIP_Ld_Reg(SIP_Ld_Reg_sig);
	my_controlunit->SOP_Ld_Reg(SOP_Ld_Reg_sig);
	my_controlunit->SVOP_Ld_Reg(SVOP_Ld_Reg_sig);
	my_controlunit->mux_B_sel(mux_B_sel_sig);
	my_controlunit->PC_reg_ld(PC_reg_ld_sig);
	my_controlunit->data_write(data_write_sig);
	my_controlunit->mux_DMR_sel(mux_DMR_sel_sig);
	my_controlunit->mux_DMW_sel(mux_DMW_sel);
	my_controlunit->alu_op(alu_op_sig);
	my_controlunit->mux_A_sel(mux_A_sel_sig);
	my_controlunit->mux_PC_sel(mux_PC_sel_sig);
	my_controlunit->mux_RF_sel(mux_RF_sel_sig);
	my_controlunit->mux_DM_Data_sel(mux_DM_Data_sel_sig);
	my_controlunit->sel_x(sel_x_sig);
	my_controlunit->sel_z(sel_z_sig);
	my_controlunit->wr_dest(wr_dest_sig);

  }

};
#endif // processor_h_

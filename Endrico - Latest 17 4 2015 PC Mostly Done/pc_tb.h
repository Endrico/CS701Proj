// testbench for PC block

// add the .h file here.
#include "PC.h"
#include "prog_mem.h"

SC_MODULE(assignment_test_bench)
{
	sc_signal<bool> t_clock;
	sc_signal<bool> t_pc_reg_ld;
	sc_signal<sc_uint<2> > t_pc_in_mux;
	
	sc_signal<sc_uint<16> > t_operand;
	sc_signal<sc_uint<16> > t_rx_out;
	sc_signal<sc_uint<16> > t_data_out; //data memory out
	
	sc_signal<sc_logic> lg_CLK;
	sc_signal<sc_uint<16> > t_I;
	sc_signal<sc_int<16> > t_D;
	sc_signal<sc_lv<16> > t_Ilv;
	sc_signal<sc_lv<16> > t_Dlv;
	sc_signal<sc_logic> t_wren;
	sc_signal<sc_lv<16> > t_rd_mem, t_wr_mem;
	
	void clock_generator();
	void mux_sel_gen();
	void operand_gen();
	void rx_gen();
	void data_out_gen();
	void PC_ld_gen();
	
	PC my_pc;
	prog_mem *my_prog_mem;
	
	 void datatransform() {
		t_I = t_Ilv.read().to_uint();
		t_Dlv = t_D.read();
		lg_CLK =  static_cast<sc_logic> (t_clock.read());
	  }
	
		SC_CTOR(assignment_test_bench)
		: my_pc("my_pc") // what is this statement doing DOG!
    {
	
		t_D = 0x0000;
		t_wr_mem = 0;
		
		SC_METHOD(datatransform);
		sensitive << t_Ilv << t_Dlv << t_clock;

		SC_THREAD(clock_generator);
		SC_THREAD(mux_sel_gen);
		SC_THREAD(operand_gen);
		SC_THREAD(rx_gen);
		SC_THREAD(data_out_gen);
		SC_THREAD(PC_ld_gen);
		//Input
		my_pc.CLK(t_clock);
		my_pc.PC_mux_in(t_pc_in_mux);
		my_pc.Operand(t_operand);
		my_pc.Rx(t_rx_out);
		my_pc.Data_out(t_data_out);
		my_pc.PC_reg_ld(t_pc_reg_ld);
		//Output
		my_pc.Prog_mem_out(t_I);
	
		//Mem
		my_prog_mem = new prog_mem("my_prog_mem", "work.prog_mem");
		my_prog_mem->clock(lg_CLK);
		my_prog_mem->data(t_Dlv);
		my_prog_mem->rdaddress(t_rd_mem);
		my_prog_mem->wraddress(t_wr_mem);
		my_prog_mem->wren(t_wren);
		my_prog_mem->q(t_Ilv);
	
	}
	
};
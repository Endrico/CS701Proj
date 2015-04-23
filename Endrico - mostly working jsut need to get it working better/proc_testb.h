// proc_testb.cpp

#include "processor.h"

SC_MODULE(test_bench)
{
  sc_signal<bool> t_run, t_clock, t_reset, t_done, t_alu_operation, t_selA, t_selB, t_selC, t_wr_en;
  sc_signal<sc_uint<16> > t_I_in, t_alu_out, t_in_A, t_in_B, t_instruction, t_operand, t_wr_dest;
  sc_signal<sc_uint<4> > t_sel_x, t_sel_z;
  sc_signal<sc_uint<2> > t_ld_IR;

  processor my_proc;
  //InstructionR my_instruction;
 // Control my_control;
 // ALU my_alu;
  
  void run_gen();
  void clock_gen();
  void instructionSet();
  void reset_gen();

  SC_CTOR(test_bench) 
    : my_proc("my_proc")//, my_alu("my_alu"), my_instruction("my_instruction"),my_control("my_control")
  {
  
	SC_THREAD(run_gen);
	SC_THREAD(clock_gen);
	SC_THREAD(reset_gen);
	SC_THREAD(instructionSet);
	
	/* my_control.run(t_run);
	my_control.reset(t_reset);
	my_control.clock(t_clock);
	my_control.done(t_done);
	my_control.sel_A(t_selA);
	my_control.sel_B(t_selB);
	my_control.sel_C(t_selC);
	my_control.alu_op(t_alu_operation);
	my_control.ld_IR(t_ld_IR);
	my_control.Instruction(t_instruction);
	my_control.sel_x(t_sel_x);
	my_control.sel_z(t_sel_z);
	my_control.wr_en(t_wr_en);
	my_control.wr_dest(t_wr_dest); */
	
    my_proc.clock_in(t_clock);
	my_proc.s_done(t_done);
    my_proc.s_run(t_run); 
	my_proc.s_reset(t_reset); 
	my_proc.s_I_in(t_I_in);
	
	/* my_alu.q_out(t_alu_out);
	my_alu.alu_operation(t_alu_operation);
	my_alu.in_A(t_in_A);
	my_alu.in_B(t_in_B);
	
	my_instruction.ld_IR(t_ld_IR);
	my_instruction.I_in(t_I_in);
	my_instruction.clock(t_clock);
	my_instruction.instruction(t_instruction);
	my_instruction.operand(t_operand); */
  }
};


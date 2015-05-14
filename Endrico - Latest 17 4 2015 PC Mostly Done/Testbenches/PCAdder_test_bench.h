//PCAdder_test_bench.h

#include "systemc.h"

#include "Register.h"
#include "PCAdder.h"

SC_MODULE(PCAdder_test_bench)
{
  sc_signal<bool> t_clock;
  sc_signal<bool> t_ld;
  
  sc_signal<sc_uint<16> > t_input;
  sc_signal<sc_uint<16> > t_output;

  Register my_Register;
  PCAdder my_PCAdder;
  
  void clock_gen();
  void ld_gen();
  void data_gen();

  SC_CTOR(PCAdder_test_bench)
    : my_Register("my_Register"), my_PCAdder("my_PCAdder")
  {
	SC_THREAD(clock_gen);
	SC_THREAD(ld_gen);
	SC_THREAD(data_gen);
	
    my_Register.CLK(t_clock);
    my_Register.Ld_Reg(t_ld);
    my_Register.Input(t_input);
    my_Register.Output(t_output);
	
	my_PCAdder.Input(t_output);
	my_PCAdder.Output(t_input);

  }
};

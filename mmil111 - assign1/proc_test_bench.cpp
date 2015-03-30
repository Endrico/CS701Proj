// proc_test_bench.cpp

#include "systemc.h"

#include "processor.h"
#include "Task1Code.h"

SC_MODULE(I_gen)
{
  sc_in<bool> CLK;
  sc_out<sc_uint<16> > I_out;

  void I_gener();

  SC_CTOR(I_gen)
  {
    SC_THREAD(I_gener);
    dont_initialize();
    sensitive << CLK.pos();
  }
};

void I_gen::I_gener()
{
  for(int count = 0; count < I_REG_SIZE; count++)
  {
    I_out.write(I_reg[count]);
    wait();
  }
}

SC_MODULE(proc_test_bench)
{
  sc_clock t_clock;
  sc_signal<bool> t_run;
  sc_signal<bool> t_reset;
  sc_signal<sc_uint<16> > t_I;
  sc_signal<sc_int<16> > t_D;
  sc_signal<bool> t_done;

  I_gen *my_I_gen;
  processor my_processor;

  SC_CTOR(proc_test_bench)
    : t_clock("clock", 20),
      my_processor("my_processor")
  {
	t_D = 0x0000;
	t_reset = 0;
	t_run = 1;
  
    my_I_gen = new I_gen("my_I_gen");
    my_I_gen->CLK(t_clock);
    my_I_gen->I_out(t_I);

    my_processor.CLK(t_clock);
    my_processor.reset(t_reset);
    my_processor.run(t_run);
    my_processor.I_in(t_I);
    my_processor.D_in(t_D);
    my_processor.done(t_done);
  }
};

SC_MODULE_EXPORT(proc_test_bench);

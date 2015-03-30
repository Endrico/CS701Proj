// proc_test_bench_2.h

#include "systemc.h"

#include "processor.h"
#include "mem.h"
#include "counter.h"

SC_MODULE(proc_test_bench_2)
{
  sc_clock t_clock;
  sc_signal<sc_logic> lg_CLK;
  sc_signal<bool> t_run;
  sc_signal<bool> t_reset;
  sc_signal<sc_uint<16> > t_I;
  sc_signal<sc_int<16> > t_D;
  sc_signal<sc_lv<16> > t_Ilv;
  sc_signal<sc_lv<16> > t_Dlv;
  sc_signal<bool> t_done;
  sc_signal<sc_logic> t_wren;
  sc_signal<sc_lv<14> > t_rd_mem, t_wr_mem;

  processor my_processor;
  mem *the_mem;
  counter *the_counter;
  
  void datatransform() {
	t_I = t_Ilv.read().to_uint();
	t_Dlv = t_D.read();
	lg_CLK =  static_cast<sc_logic> (t_clock.read());
  }
  
  SC_CTOR(proc_test_bench_2)
    : t_clock("clock", 20),
      my_processor("my_processor")
  {
	t_D = 0x0000;
	t_reset = 0;
	t_run = 1;
	t_wr_mem = 0;

    SC_METHOD(datatransform);
    sensitive << t_Ilv << t_Dlv << t_clock;
	
    my_processor.CLK(t_clock);
    my_processor.reset(t_reset);
    my_processor.run(t_run);
    my_processor.I_in(t_I);
    my_processor.D_in(t_D);
    my_processor.done(t_done);
	
	the_mem = new mem("the_mem", "work.mem");
    the_mem->clock(lg_CLK);
    the_mem->data(t_Dlv);
    the_mem->rdaddress(t_rd_mem);
    the_mem->wraddress(t_wr_mem);
    the_mem->wren(t_wren);
    the_mem->q(t_Ilv);
	
	the_counter = new counter("the_counter", "work.counter");
	the_counter->CLK(lg_CLK);
	the_counter->C_Out(t_rd_mem);
  }
};

SC_MODULE_EXPORT(proc_test_bench_2);

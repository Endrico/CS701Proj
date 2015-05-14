// PCAdder_test_bench.cpp

#include "PCAdder_test_bench.h"

#ifdef MTI_SYSTEMC

void PCAdder_test_bench::clock_gen()
{
	while(1){
	t_clock.write(false);
	wait(20, SC_NS);
	t_clock.write(true);
	wait(20, SC_NS);
	}
}

void PCAdder_test_bench::ld_gen()
{
	while(1){
	t_ld.write(false);
	wait(60, SC_NS);
	t_ld.write(true);
	wait(60, SC_NS);
	}
}

void PCAdder_test_bench::data_gen()
{
	t_input = 0xff;
	wait(20, SC_NS);
	t_input = 0xA3;
	wait(20, SC_NS);
	t_input = 0xB6;
	wait(20, SC_NS);
	t_input = 0xf1;
}
SC_MODULE_EXPORT(PCAdder_test_bench);
#else
// OSCI sc_main code
#endif
#include "pc_tb.h"

#ifdef MTI_SYSTEMC

void assignment_test_bench::clock_generator()
{
	while(1)
	{
		t_clock.write(false);
		wait(10, SC_NS);
		t_clock.write(true); 
		wait(10, SC_NS);
		t_clock.write(false); 
   }
}
void assignment_test_bench::mux_sel_gen()
{

		t_pc_in_mux = 0 ;
		wait(100, SC_NS);
		t_pc_in_mux = 1 ;
		wait(100, SC_NS);
		t_pc_in_mux = 2 ;
		wait(100, SC_NS);
		t_pc_in_mux = 3 ;
		wait(100, SC_NS);
   
}

void assignment_test_bench::operand_gen()
{
	while(1)
	{
		t_operand = 0xAA;
		wait(100, SC_NS);
		t_operand = 0xBB; 
		wait(100, SC_NS);
   }
}

void assignment_test_bench::rx_gen()
{
	while(1)
	{
		t_rx_out = 0xCC;
		wait(100, SC_NS);
		t_rx_out = 0xDD; 
		wait(100, SC_NS);
   }
}

void assignment_test_bench::data_out_gen()
{
	while(1)
	{
		t_data_out = 0xEE;
		wait(100, SC_NS);
		t_data_out = 0xFF; 
		wait(100, SC_NS);
   }
}

void assignment_test_bench::PC_ld_gen()
{
	t_pc_reg_ld.write(true);

}


   SC_MODULE_EXPORT(assignment_test_bench);
#else 
  // OSCI sc_main code
#endif

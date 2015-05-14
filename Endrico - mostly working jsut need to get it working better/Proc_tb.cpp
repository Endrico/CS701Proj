#include "Proc_tb.h"

#ifdef MTI_SYSTEMC

void assignment_test_bench::clock_generator()
{
	while(1)
	{
		t_clock.write(false);
		wait(10, SC_NS);
		t_clock.write(true); 
		wait(10, SC_NS);
		
   }
}
void assignment_test_bench::reset_gen()
{

	t_reset.write(false);
	/*wait(30, SC_NS);
	t_reset.write(true); 
	wait(10, SC_NS);
	t_reset.write(false);*/
		
}

/*void assignment_test_bench::er_gen()
{

	t_er.write(false);
	wait(100, SC_NS);
	t_er.write(true);
	wait(100, SC_NS);
	t_er.write(false);

}*/

void assignment_test_bench::dprr_gen()
{

	t_dprr = 0;
	wait(100, SC_NS);
	t_dprr = 1; 
	wait(100, SC_NS);
	t_dprr = 2; 
	wait(100, SC_NS);
	t_dprr = 3; 
	wait(100, SC_NS);
	t_dprr = 4; 

}
	
void assignment_test_bench::sip_gen()
{
	while(1)
	{
		t_sip = 0x01;
		wait(100, SC_NS);
		t_sip = 0x03; 
		wait(100, SC_NS);
   }
}

void assignment_test_bench::m_out_gen()
{
	while(1)
	{
		t_sip = 0x02;
		wait(100, SC_NS);
		t_sip = 0x04; 
		wait(100, SC_NS);
   }
}

   SC_MODULE_EXPORT(assignment_test_bench);
#else 
  // OSCI sc_main code
#endif

#include "proc_testb.h"

#ifdef MTI_SYSTEMC
void test_bench::run_gen()
{
	wait(40, SC_NS);
	t_run.write(true);
	wait(500, SC_NS);
	t_run.write(false);
}
	
void test_bench::clock_gen()
{
	while(true)
	{
		t_clock.write(true);
		wait(20, SC_NS);
		t_clock.write(false);
		wait(20, SC_NS);
	}
}
	
void test_bench::instructionSet()
{
	while(true){
		
		wait(80, SC_NS); 	// wait clock period cycle 2	
		t_I_in = 16384;		// Load operand into R0			//
		wait(40, SC_NS); 	// wait clock period cycle 2	//  Instruction 1
		t_I_in = 1;		// Operand = 1					//
		wait(40, SC_NS); 	// wait clock period cycle 3	//
		t_I_in = 50;		// Garbage						//
		
		wait(40, SC_NS);	// wait clock period cycle 1    //
		t_I_in = 16400;		// Load operand into R1         //
		wait(40, SC_NS);	// wait clock period cycle 2    //
		t_I_in = 2;			// Operand = 1                  //  Instruction 2
		wait(40, SC_NS); 	// wait clock period cycle 3    //
		t_I_in = 50;		// Garbage                      //

		wait(40, SC_NS);	// wait clock period cycle 1    //
		t_I_in = 63489; 	// ADD R0<-R0 + R1              //
		wait(40, SC_NS);	// wait clock period cycle 2    //  Instruction 3
		t_I_in = 100; 		// garbage                      //
		wait(40, SC_NS); 	// wait clock period cycle 3    //
		t_I_in = 50;		// Garbage                      //

		wait(40, SC_NS);	// wait clock period cycle 1   //
		t_I_in = 51201;		// AND R0<-R0 & R1             //
		wait(40, SC_NS);	// wait clock period cycle 2   //  Instruction 4
		t_I_in = 100;		// garbage                     //
		wait(40, SC_NS); 	// wait clock period cycle 3   //
		t_I_in = 50;		// Garbage                     //
	}


}

void test_bench::reset_gen()
{
	wait(1000, SC_NS);
	t_reset.write(true);
	wait(20, SC_NS);
	t_reset.write(false);

}
	
   SC_MODULE_EXPORT(test_bench);
#else 
  // OSCI sc_main code
#endif


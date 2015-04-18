// testbench for Processor

#include "Processor.h"

SC_MODULE(assignment_test_bench)
{
	// Input signals into the processor
	sc_signal<bool> t_clock;
	sc_signal<bool> t_reset;
	sc_signal<bool> t_er;
	sc_signal<sc_uint<2> > t_dprr;
	sc_signal<sc_uint<16> > t_sip;
	sc_signal<sc_uint<16> > t_m_out;
	
	//Output Signals from the processor
	sc_signal<bool> t_we;
	sc_signal<bool> t_clr_irq;
	sc_signal<bool> t_eot;
	sc_signal<bool> t_dpc;
	sc_signal<sc_uint<12> > t_dpcr_ccd;
	sc_signal<sc_uint<4> > t_ccd;
	sc_signal<sc_uint<4> > t_pcd;
	sc_signal<sc_uint<16> > t_sop;
	sc_signal<sc_uint<16> > t_svop;
	sc_signal<sc_uint<16> > t_data;
	sc_signal<sc_uint<13> > t_addr;
	
	void clock_generator();
	void reset_gen();
	void er_gen();
	void dprr_gen();
	void sip_gen();
	void m_out_gen();

	
	Processor my_processor;
	
		SC_CTOR(assignment_test_bench)
		: my_processor("my_processor") // what is this statement doing DOG!
    {

		SC_THREAD(clock_generator);
		SC_THREAD(reset_gen);
		SC_THREAD(er_gen);
		SC_THREAD(dprr_gen);
		SC_THREAD(sip_gen);
		SC_THREAD(m_out_gen);
		
		//Inputs
		my_processor.CLK(t_clock);		// 1-bit
		my_processor.RST_L(t_reset);	// 1-bit
		my_processor.DPRR(t_dprr);		// 2-bit
		my_processor.SIP(t_sip);		// 16-bit	
		my_processor.ER(t_er);			// 1-bit
		my_processor.M_OUT(t_m_out);	// 16-bit
		
		//Outputs
		my_processor.WE(t_we);			// 1-bit
		my_processor.CLR_IRQ(t_clr_irq);// 1-bit
		my_processor.EOT(t_eot);				// 1-bit
		my_processor.DPC(t_dpc);				// 1-bit
		my_processor.DPCR_CCD(t_dpcr_ccd); 		// 12-bit
		my_processor.CCD(t_ccd);		 		// 4-bit
		my_processor.PCD(t_pcd);		 		// 4-bit
		my_processor.SOP(t_sop);				// 16-bit
		my_processor.SVOP(t_svop);			// 16-bit
		my_processor.DATA(t_data);			// 16-bit
		my_processor.ADDR(t_addr);			// 13-bit
	
	}
	
};
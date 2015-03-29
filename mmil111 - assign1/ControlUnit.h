#ifndef __ControlUnit_h_
#define __ControlUnit_h_

#include "systemc.h"

SC_MODULE(ControlUnit)
{
  sc_in<bool> run;
  sc_in<bool> reset;
  sc_in<bool> CLK;
  sc_in<sc_bv<16> > IR_op;
  sc_out<bool> done;
  sc_out<bool> ld_IR;

  sc_out<sc_bv<4> > sel_X;
  sc_out<sc_bv<4> > sel_Z;
  sc_out<bool> wr_en;
  sc_out<sc_bv<4> > wr_dest;

  sc_out<bool> sel_A;
  sc_out<bool> sel_B;
  sc_out<sc_bv<2> > sel_C;
  sc_out<bool> alu_op;
  
  sc_bv<6> temp;

  typedef enum CU_State {
    Fetch,
    Decode,
    Execute
  };
  CU_State my_state;
  

  void my_ControlUnit( );
  void CU_state_machine( );

  SC_CTOR(ControlUnit)
  {
	my_state = Decode; // If testing part 1, start at Execute
    SC_METHOD(my_ControlUnit);
    sensitive << run << reset << IR_op;
	SC_METHOD(CU_state_machine);
    sensitive << CLK.pos();
  }
};

#endif // __ControlUnit_h_

#ifndef __RF_h_
#define __RF_h_

#include "systemc.h"

SC_MODULE(RF)
{
  sc_in<bool> RST;
  sc_in<bool> CLK;
  sc_in<sc_bv<4> > sel_x;
  sc_in<sc_bv<4> > sel_z;

  sc_in<bool> wr_en;
  sc_in<sc_bv<4> > wr_dest;
  sc_in<sc_int<16> > wr_data;

  sc_out<sc_int<16> > X;
  sc_out<sc_int<16> > Z;
  sc_out<sc_int<16> > ccd;
  sc_out<sc_int<16> > pcd;

  sc_int<16> Reg[16];

  void my_RF( );

  SC_CTOR(RF)
  {
    SC_METHOD(my_RF);
    sensitive << RST << CLK.pos( ) << sel_x << sel_z;
  }
};

#endif // __RF_h_

#ifndef __processor_h_
#define __processor_h_

#include "systemc.h"
#include "ControlUnit.h"
#include "Datapath.h"

SC_MODULE(processor)
{
  sc_in<bool> CLK;
  sc_in<bool> RST_L;
  sc_in<sc_uint<2> > DPRR;
  sc_in<bool> ER;
  sc_in<sc_uint<16> > SIPi;
  sc_in<sc_uint<16> > M_OUT;

  sc_out<bool> WE;
  sc_out<bool> CLR_IRQ;
  sc_out<bool> EOT;
  sc_out<bool> DPC;
  sc_out<sc_uint<12> > DPCR_CCD;
  sc_out<sc_uint<4> > CCD;
  sc_out<sc_uint<4> > PCD;
  sc_in<sc_uint<16> > SOPi;
  sc_in<sc_uint<16> > SVOPi;
  sc_in<sc_uint<16> > DATA;
  sc_in<sc_uint<13> > ADDR;

  sc_signal<



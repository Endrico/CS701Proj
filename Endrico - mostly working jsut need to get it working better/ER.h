#ifndef __ER_h_
#define __ER_h_

#include "systemc.h"

SC_MODULE(ER)
{
  //Port
  sc_in<bool> CLR;
  sc_in<bool> SET;
  
  sc_out<bool> out;
  
  void my_ER();

  SC_CTOR(ER)
  {
    SC_METHOD(my_ER);
    sensitive << CLR << SET;
  }
  
};

#endif // __ER_h_


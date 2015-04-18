// EOT.h

#ifndef __EOT_h_
#define __EOT_h_

#include "systemc.h"

SC_MODULE(EOT)
{
  //Port
  sc_in<bool> CLR;
  sc_in<bool> SET;
  
  sc_out<bool> OUT;
  
  void my_EOT( );

  SC_CTOR(EOT)
  {
    SC_METHOD(my_EOT);
    sensitive << CLR << SET;
  }
};

#endif // __EOT_h_


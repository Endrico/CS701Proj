// IR.cpp

#include "IR.h"

void IR::my_IR()
{
  if(RST) {
    ld_top = 0;
    IReg_temp_top = 0;
    IReg_temp_bot = 0;
  }
  else if(ld_IR) {
    if(ld_top == 0) {
      IReg_temp_top = I_in;
      ld_top = 1;
    } else {
      IReg_temp_bot = I_in;
    }
  } else {
    ld_top = 0;
  }
  
  IReg = (IReg_temp_top, IReg_temp_bot);
}


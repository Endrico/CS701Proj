// PCR.cpp

#include "PCR.h"

void PCR::my_PCR()
{
  if(ld_PCR) {
    if(ld_top == 0) {
      PCReg_temp_top = I_in;
      ld_top = 1;
    } else {
      PCReg_temp_bot = I_in;
    }
  } else {
    ld_top = 0;
  }
  
  PCReg = (PCReg_temp_top, PCReg_temp_bot);
}


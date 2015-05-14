//DPRegisters.cpp

#include "DPRegisters.h"

void DPRegisters::my_DPRegisters()
{
  if(RST) {
    Reg_temp = 0;
  } else if(Ld_Reg) {
    Reg_temp = Input;
  }
  Output = Reg_temp;
}
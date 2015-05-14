//Register.cpp

#include "Register.h"

void Register::my_Register()
{
  if(RST) {
    Reg_temp = 0;
  } else if(Ld_Reg) {
    Reg_temp = Input;
  }
  Output = Reg_temp;
}


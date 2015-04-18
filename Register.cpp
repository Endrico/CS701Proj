//Register.cpp

#include "Register.h"

void Register::my_Register()
{
  if(Ld_Reg) {
    Reg_temp = Input;
  }
  Output = Reg_temp;
}




//Register.cpp

#include "Register.h"

void Register::my_Register()
{
  if(RST.read()) {
    Reg_temp = 0;
  } else if(Ld_Reg.read()) {
    Reg_temp = Input;
  }
  Output.write(Reg_temp);
}


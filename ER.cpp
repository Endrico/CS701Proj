//ER.cpp

#include "ER.h"

void ER::my_ER()
{
  if(SET) {
    OUT = true;
  } else if(CLR) {
    OUT = false;
  }
}



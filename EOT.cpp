//EOT.cpp

#include "EOT.h"

void EOT::my_EOT()
{
  if(SET) {
    OUT = true;
  } else if(CLR) {
    OUT = false;
  }
}




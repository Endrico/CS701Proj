//EOT.cpp

#include "EOT.h"

void EOT::my_EOT()
{
  if(SET) {
    Out.write(true);
  } else if(CLR) {
    Out.write(false);
  }
}




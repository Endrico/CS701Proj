// PCAdder.cpp

#include "PCAdder.h"

void PCAdder::my_PCAdder()
{
  switch(PCAdder_op)
  {
    case 0:
      out = A.read() + B.read();
      break;
    case 1:
      out = A.read() & B.read();
      break;
  }
}


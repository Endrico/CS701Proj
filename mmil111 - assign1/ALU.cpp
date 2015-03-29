// ALU.cpp

#include "ALU.h"

void ALU::my_ALU()
{
  switch(alu_op)
  {
    case 0:
      out = A.read() + B.read();
      break;
    case 1:
      out = A.read() & B.read();
      break;
  }
}


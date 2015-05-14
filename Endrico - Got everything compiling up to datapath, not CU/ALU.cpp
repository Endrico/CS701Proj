// ALU.cpp

#include "ALU.h"

void ALU::my_ALU()
{
  switch(alu_op.read())
  {
    case 0:
      out = A.read() + B.read();
      break;
    case 1:
      out = B.read() - A.read();
      break;
    case 2:
      out = A.read() & B.read();
      break;
    case 3:
      out = A.read() | B.read();
      break;
  }
  if (out.read() == 0) {
    Z.write(1);
  }
  if (clrz == 1) {
    Z.write(0);
  }
}


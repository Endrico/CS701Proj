// Mul4.cpp

#include "Mul4.h"

void Mul4::my_mul4( )
{
  //int sel = select.read().to_uint();
  if(select.read() == 0) {
    out = in1;
  } else if (select.read() == 1) {
    out = in2;
  } else if (select.read() == 2) {
    out = in3;
  } else if (select.read() == 3) {
    out = in4;
  }
}



// Mul4.cpp

#include "Mul4.h"

void Mul4::my_mul4( )
{
  int sel = select.read().to_uint();
  if(sel == 0) {
    out = in1;
  } else if (sel == 1) {
    out = in2;
  } else if (sel == 2) {
    out = in3;
  } else if (sel == 3) {
    out = in4;
  }
}



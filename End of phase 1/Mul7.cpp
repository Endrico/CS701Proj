// Mul7.cpp

#include "Mul7.h"

void Mul7::my_Mul7( )
{
  int sel = select.read();
  switch(sel) {
    case 0:
      out = in1;
      break;
    case 1:
      out = in2;
      break;
    case 2:
      out = in3;
      break;
    case 3:
      out = in4;
      break;
    case 4:
      out = in5;
      break;
    case 5:
      out = in6;
      break;
    case 6:
      out = in7;
      break;
  }
}




// RF.cpp

#include "RF.h"

void RF::my_RF()
{
  if(RST) {
    for (unsigned int i = 0; i < 16; i++)
      Reg[i] = 0;
  } else {
    if(CLK == 1) { // Could not find positive edge because of boolean definition (CLK.pos())
      if(wr_en) {
        Reg[wr_dest.read()] = wr_data;
      }
    }
    X = Reg[sel_x.read()];
    Z = Reg[sel_z.read()];
    ccd = Reg[7];
    pcd = Reg[8];
  }
}


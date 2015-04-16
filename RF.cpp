// RF.cpp

#include "RF.h"

void RF::my_RF()
{
  if(RST) {
    for (int i = 0; i < 16; i++)
      Reg[i] = 0;
  } else {
    if(CLK.pos()) {
      if(wr_en) {
        Reg[wr_dest.read().to_uint()] = wr_data;
      }
    }
    X = Reg[sel_x.read().to_uint()];
    Z = Reg[sel_z.read().to_uint()];
    ccd = Reg[7];
    pcd = Reg[8];
  }
}


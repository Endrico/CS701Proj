// RF.cpp

#include "RF.h"

void RF::my_RF()
{
  X = Reg[sel_x.read().to_uint()];
  Z = Reg[sel_z.read().to_uint()];
  if(wr_en) {
    Reg[wr_dest.read().to_uint()] = wr_data;
  }
}


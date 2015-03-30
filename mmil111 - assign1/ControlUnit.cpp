// ControlUnit.cpp
// Author: Michael Miller, mmil111
// See the table in "Assignment 1 Report" for details of the control signal assignments

#include "ControlUnit.h"

void ControlUnit::CU_state_machine( )
{
  switch(my_state) {
    case Fetch:
      my_state = Decode;
      break;
    case Decode:
      my_state = Execute;
      break;
    case Execute:
      my_state = Fetch;
      break;
  }
  // cannot make a sc_signal with a custom typedef for a sensitivity list
  // so have the signals that are sequential happening here
  switch(my_state) {
    case Fetch:
      ld_IR = 1;
      wr_en = 0;
      done = 0;
      break;
    case Decode:
      ld_IR = 1;
      break;
    case Execute:
      ld_IR = 0;
      if(IR_op.read().range(15,14) != 0x00)
        wr_en = 1;
      break;
  }
}

void ControlUnit::my_ControlUnit( )
{
  temp = IR_op.read().range(13,8);
  if(reset) {
    done = 0;
    ld_IR = 0;
    wr_en = 0;

  } else {
    switch(my_state) {
      case Fetch:
        break;
      case Decode:
        if(IR_op.read().range(15,14) == 0x03) // Register mode
        {
          sel_X = IR_op.read().range(3,0);
          sel_Z = IR_op.read().range(7,4);
          wr_dest = IR_op.read().range(7,4);
        } else if (IR_op.read().range(15,14) == 0x01) // Immediate mode
        {
          sel_B = 1;
          wr_dest = IR_op.read().range(7,4);
        }

        if(IR_op.read().range(13,8) == 0x38) // ADD
        {
          sel_A = 0;
          sel_B = 0;
          alu_op = 0;
          sel_C = 0x02;
        }
        else if(IR_op.read().range(13,8) == 0x08) // AND
        {
          sel_A = 0;
          sel_B = 0;
          alu_op = 1;
          sel_C = 0x02;
        }
        else if(IR_op.read().range(13,8) == 0x00) // LDR
        {
          sel_C = 0x01;
        }
        break;
      case Execute:
        if(IR_op.read().range(15,14) == 0x03) // Register mode
        {
          wr_dest = IR_op.read().range(7,4);
        } else if (IR_op.read().range(15,14) == 0x01) // Immediate mode
        {
          wr_dest = IR_op.read().range(7,4);
        }

        if(IR_op.read().range(29-16,24-16) == 0x38) // ADD
        {
          sel_C = 0x02;
        }
        else if(IR_op.read().range(29-16,24-16) == 0x08) // AND
        {
          sel_C = 0x02;
        }
        else if(IR_op.read().range(29-16,24-16) == 0x00) // LDR
        {
          sel_C = 0x01;
        }

        done = 1;
        break;
    }
  }
}


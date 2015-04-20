// ControlUnit.cpp

#include "ControlUnit.h"

void ControlUnit::Pulse_Distributor( )
{
  switch(state.read()) {
    case Init:
      if(debug_hold) state = Test;
      else state = E0;
      break;
//    case Test:
//      break;
//    case Test2:
//      break;
    case E0:
      break;
    case E1:
      break;
    case E1bis:
      break;
    case E2:
      break;
    case T0:
      state = T1;
      break;
    case T1:
      state = T2;
      break;
    case T2:
      if(debug_hold) state = Test;
      else state = E0;
      break;
//    case T3:
//      if(debug_hold) state = Test;
//      else state = E0;
//      break;
  }

}

void ControlUnit::Operation_Decoder( )
{
  AM = I_code.read().range(15,14);
  Opcode = I_code.read().range(13,8);
  Rz = I_code.read().range(7,4);
  Rx = I_code.read().range(3,0);

  switch(state.read()) {
    case Init:
      break;
//    case Test:
//      break;
//    case Test2:
//      break;
    case E0:
      break;
    case E1:
      break;
    case E1bis:
      break;
    case E2:
      break;
    case T0:
      ld_IR = 1;
      PC_reg_ld = 1;
      mux_PC_sel = 0x0;
      break;
    case T1:
      if(AM == 0x0) // Inherent mode
      {
        // T1 Noop
        ld_IR = 0;
        PC_reg_ld = 0;
      }
      else if(AM == 0x1) // Immediate mode
      {
        // Load Operand, advance PC by 1
        ld_IR = 1;
        PC_reg_ld = 1;
        mux_PC_sel = 0x0;
      }
      else if(AM == 0x2) //Direct mode
      {
        // Load Operand, advance PC by 1
        ld_IR = 1;
        PC_reg_ld = 1;
        mux_PC_sel = 0x0;
      }
      else if(AM == 0x3) // Register mode
      {
        // T1 Noop
        ld_IR = 0;
        PC_reg_ld = 0;
      }

      if(Opcode == 0x36) //LER
      {
        ER_Ld_Reg = 1;
      }
      else if(Opcode == 0x37) //LSIP
      {
        SIP_Ld_Reg = 1;
      }
      break;
    case T2:
      ld_IR = 0;
      PC_reg_ld = 0;

      if(AM == 0x0)
      {
        if(Opcode == 0x10) //CLFZ
        {
          clrz = 1;
        }
        else if(Opcode == 0x34) //CER
        {
          clrer = 1;
        }
        else if(Opcode == 0x3C) //CEOT
        {
          clreot = 1;
        }
        else if(Opcode == 0x3E) //SEOT
        {
          seteot = 1;
        }
        else if(Opcode == 0x3F) //NOOP
        {
        }
      }
      else if(AM == 0x1)
      {
        if(Opcode == 0x8) //AND
        {
        }
        else if(Opcode == 0xC) //OR
        {
        }
        else if(Opcode == 0x38) //ADD
        {
        }
        else if(Opcode == 0x3) //SUBV
        {
        }
        else if(Opcode == 0x4) //SUB
        {
        }
        else if(Opcode == 0x0) //LDR
        {
        }
        else if(Opcode == 0x2) //STR
        {
        }
        else if(Opcode == 0x18) //JMP
        {
        }
        else if(Opcode == 0x1C) //PRESENT
        {
        }
        else if(Opcode == 0x28) //DCALLBL
        {
        }
        else if(Opcode == 0x29) //DCALLNB
        {
        }
        else if(Opcode == 0x14) //SZ
        {
        }
        else if(Opcode == 0x1E) //MAX
        {
        }
      }
      else if(AM == 0x2)
      {
        if(Opcode == 0x0) //LDR
        {
        }
        else if(Opcode == 0x2) //STR
        {
        }
        else if(Opcode == 0x1D) //STRPC
        {
        }
      }
      else if(AM == 0x3)
      {
        if(Opcode == 0x8) //AND
        {
        }
        else if(Opcode == 0xC) //OR
        {
        }
        else if(Opcode == 0x38) //ADD
        {
        }
        else if(Opcode == 0x0) //LDR
        {
        }
        else if(Opcode == 0x2) //STR
        {
        }
        else if(Opcode == 0x18) //JMP
        {
        }
        else if(Opcode == 0x28) //DCALLBL
        {
        }
        else if(Opcode == 0x29) //DCALLNB
        {
        }
        else if(Opcode == 0x36) //LER
        {
        }
        else if(Opcode == 0x3B) //SSVOP
        {
        }
        else if(Opcode == 0x37) //LSIP
        {
        }
        else if(Opcode == 0x3A) //SSOP
        {
        }
      }
      break;
//    case T3:
//      break;
  }

}

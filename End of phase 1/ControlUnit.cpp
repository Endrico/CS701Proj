// ControlUnit.cpp

#include "ControlUnit.h"
#include <stdio.h>

void ControlUnit::Pulse_Distributor()
{
if (CLK){
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
		  if(DPC == 1 && IRQ == 1)
		  {
			//R15 = M[HP](7..0)
			state = E1;
		  }
		  else if(DPC == 0 && IRQ == 0)
		  {
			if(ld_dprr_done)
			{
			  CLR_IRQ = 0;
			}
			// HP - TP
			state = E2;
		  }
		  else
		  {
			if(IRQ == 0 && ld_dprr_done == 1)
			{
			  CLR_IRQ = 0;
			}
			state = T0;
		  }
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
}

void ControlUnit::Data_transform()
{

  AM = I_code.read().range(15,14);
  Opcode = I_code.read().range(13,8);
  Rz = I_code.read().range(7,4);
  Rx = I_code.read().range(3,0);
  }
  
void ControlUnit::Operation_Decoder()
{
  
  cout << "Instruction " << I_code.read() << endl; 
  cout << "AM: " << AM<<endl;
  cout << "Op: " << Opcode<<endl;
  cout << "Rx: " << Rx<<endl;
  cout << "Rz: " << Rz<<endl;
  

  switch(state.read()) {
    case Init:
      break;
//    case Test:
//      wr_en = 0;
//      ld_IR = 0;
//      PC_reg_ld = 0;
//      ER_Ld_Reg = 0;
//      SIP_Ld_Reg = 0;
//      SVOP_Ld_Reg = 0;
//      SOP_Ld_Reg = 0;
//      clrz = 0;
//      clrer = 0;
//      clreot = 0;
//      seteot = 0;
//      data_write = 0;
//      break;
//    case Test2:
//      break;
    case E0:
      wr_en = 0;
      ld_IR = 0;
      PC_reg_ld = 0; // changed this to ld the PC register 1 cycle earlier
      ER_Ld_Reg = 0;
      SIP_Ld_Reg = 0;
      SVOP_Ld_Reg = 0;
      SOP_Ld_Reg = 0;
      clrz = 0;
      clrer = 0;
      clreot = 0;
      seteot = 0;
      data_write = 0;
      break;
    case E1:
      break;
    case E1bis:
      break;
    case E2:
      break;
    case T0:
      ld_IR = 1;
      mux_PC_sel = 0x0;
      PC_reg_ld = 1;
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
        else if(Opcode == 0x1C) //PRESENT
        {
          clrz = 1;
          alu_op = 0; //ADD
          sel_x = 0; //R0
          sel_z = Rz; //Rz
          mux_A_sel = 0; //Rx
          mux_B_sel = 0; //Rz
        }
      }
      else if(AM == 0x1)
      {
        if(Opcode == 0x8) //AND
        {
          alu_op = 2;
          sel_x = Rx;
          mux_A_sel = 1; //Operand
          mux_B_sel = 1; //Rx
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0xC) //OR
        {
          alu_op = 3;
          sel_x = Rx;
          mux_A_sel = 1; //Operand
          mux_B_sel = 1; //Rx
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x38) //ADD
        {
          alu_op = 0;
          sel_x = Rx;
          mux_A_sel = 1; //Operand
          mux_B_sel = 1; //Rx
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x3) //SUBV
        {
          alu_op = 1;
          sel_x = Rx;
          mux_A_sel = 1; //Operand
          mux_B_sel = 1; //Rx
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x4) //SUB
        {
          alu_op = 1;
          sel_x = Rx;
          mux_A_sel = 1; //Operand
          mux_B_sel = 1; //Rx
        }
        else if(Opcode == 0x0) //LDR
        {
			cout << "got here too" << endl;
          mux_RF_sel = 0; //Operand
		  //ld_IR = 1;
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x2) //STR
        {
          mux_DMW_sel = 0; // M[Rz]
          mux_DM_Data_sel = 1; //Operand
          data_write = 1;
        }
        else if(Opcode == 0x18) //JMP
        {
          mux_PC_sel = 1; //Operand
          PC_reg_ld = 1;
        }
        else if(Opcode == 0x1C) //PRESENT
        {
          clrz = 0;
          if(zout) {
            mux_PC_sel = 1;
            PC_reg_ld = 1;
          }
        }
        else if(Opcode == 0x28) //DCALLBL //TODO
        {
        }
        else if(Opcode == 0x29) //DCALLNB //TODO
        {
        }
        else if(Opcode == 0x14) //SZ
        {
          if(zout) {
            mux_PC_sel = 1;
            PC_reg_ld = 1;
          }
        }
        else if(Opcode == 0x1E) //MAX
        {
          sel_x = Rx;
          mux_A_sel = 1; //Operand
          mux_B_sel = 1; //Rx
          mux_RF_sel = 3; //max_out
          wr_dest = Rz;
          wr_en = 1;
        }
      }
      else if(AM == 0x2)
      {
        if(Opcode == 0x0) //LDR
        {
			cout << "got here 3" << endl;
          mux_DMR_sel = 1; // M[Operand]
          mux_RF_sel = 6; // DM_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x2) //STR
        {
          mux_DMW_sel = 1; // M[Operand]
          mux_DM_Data_sel = 0; //Rx
          data_write = 1;
        }
        else if(Opcode == 0x1D) //STRPC
        {
          mux_DMW_sel = 1; // M[Operand]
          mux_DM_Data_sel = 2; //PC
          data_write = 1;
        }
      }
      else if(AM == 0x3)
      {
        if(Opcode == 0x8) //AND
        {
          alu_op = 2;
          sel_x = Rx;
          sel_z = Rz;
          mux_A_sel = 0; //Rx
          mux_B_sel = 0; //Rz
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0xC) //OR
        {
          alu_op = 3;
          sel_x = Rx;
          sel_z = Rz;
          mux_A_sel = 0; //Rx
          mux_B_sel = 0; //Rz
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x38) //ADD
        {
          alu_op = 0;
          sel_x = Rx;
          sel_z = Rz;
          mux_A_sel = 0; //Rx
          mux_B_sel = 0; //Rz
          mux_RF_sel = 2; //alu_out
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x0) //LDR
        {
			cout << "got here" << endl;
          sel_x = Rx;
          mux_RF_sel = 1; //Rx
          wr_dest = Rz;
          wr_en = 1;
		  cout << "sel_x = " << sel_x << endl;
        }
        else if(Opcode == 0x2) //STR
        {
          sel_x = Rx;
          mux_DMW_sel = 0; // M[Rz]
          mux_DM_Data_sel = 0; //Rx
          data_write = 1;
        }
        else if(Opcode == 0x18) //JMP
        {
          sel_x = Rx;
          mux_PC_sel = 2; //Rx
          PC_reg_ld = 1;
        }
        else if(Opcode == 0x28) //DCALLBL //TODO
        {
        }
        else if(Opcode == 0x29) //DCALLNB //TODO
        {
        }
        else if(Opcode == 0x36) //LER
        {
          mux_RF_sel = 5; //ER_0
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x3B) //SSVOP
        {
          sel_x = Rx;
          SVOP_Ld_Reg = 1;
        }
        else if(Opcode == 0x37) //LSIP
        {
          mux_RF_sel = 4; //SIP
          wr_dest = Rz;
          wr_en = 1;
        }
        else if(Opcode == 0x3A) //SSOP
        {
          sel_x = Rx;
          SOP_Ld_Reg = 1;
        }
      }

      ld_dprr_done = 1;
      break;
//    case T3:
//      break;
  }

}

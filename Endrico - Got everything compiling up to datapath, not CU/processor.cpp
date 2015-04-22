// processor.cpp

#include "processor.h"
#include <iostream>


// Logic describing the control unit of the processor
void Control::my_Control()
{	

	if (reset)
	{
		count = 0;
		
	}
	else if (run)
	{	
		ld_IR = 0;
		if(count == 0) // Fetch stage
		{
			wr_en=0;
			done=0;
			count = 1;
			ld_IR = 1;
			cout << "this is first cycle " << endl;

		}
		else if (count == 1)
		{	
	
			AM = Instruction.read().range(15,14);
			OP = Instruction.read().range(13,8);
			Rz = Instruction.read().range(7,4);
			Rx = Instruction.read().range(4,0);
			
			cout << "this is AM : "<< AM << endl;
			cout << "this is OP : "<< OP << endl;	
			cout << "this is Rz : "<< Rz << endl;	
			cout << "this is Rx : "<< Rx << endl;	
			
			if (AM == 1){
				cout << "got here" << endl;			
				ld_IR = 2;
			} else if (AM == 3){
				ld_IR = 0;
				cout << "got here too" << endl;	
			} else { ld_IR = 0;}
			
			if (OP == 56)
			{
				// This is the ADD instruction
				sel_x = Rx;
				sel_z = Rz;
				sel_A = 0;
				sel_B = 1;
				inst = 1;
			}
			else if (OP == 8)
			{
				// This is the AND operation 
				sel_x = Rx;
				sel_z = Rz;
				sel_A = 0;
				sel_B = 1;
				inst = 2;  
			
			}
			else if (OP == 0)
			{
				// This is the Load operand operation
				wr_en = 1;		
				wr_dest = Rz;
				sel_C = 0;
				inst = 3;
			}
			done = 1;
			count = 2;
		}
		else if(count == 2)
		{			
			if (inst == 1) // Add
			{
				wr_en = 1;		
				wr_dest = Rz;
				sel_C = 1;
				alu_op = 0;	
			}
			else if (inst == 2)// And
			{
				wr_en = 1;		
				wr_dest = Rz;
				sel_C = 1;
				alu_op = 1;
			}
			else if (inst == 3)// Load
			{	

			}
			ld_IR = 0;
			inst = 0;
			count = 0;
			done=0;
		}
	}
}

// Logic describing the ALU behaviour
void ALU::my_ALU() // Done
{	
	if (!alu_operation) // This is ADD
	{
		a = in_A.read();		
		b = in_B.read();		
	
		q_out = a + b;
	
	}
	else if (alu_operation) // This is AND
	{
		a = in_A.read();		
		b = in_B.read();		
	
		q_out = a & b;
	}
	
	
}

// Logic describing the Instruction Register behaviour
void InstructionR::my_InstructionR() // DONE
{
	
	if(ld_IR.read() == 1)
	{
		cout<< "got into here" << endl;
		instruction.write(I_in.read());
	}
	else if(ld_IR.read() == 2)
	{
		cout<< "got into here 2" << endl;
		operand.write(I_in.read());
	}
	else{
		cout<< "got into here 3" << endl;
		return;
		//NoOp
	}

}

// Logic Describing the multiplexer behaviour
void Multiplexer::my_Multiplexer() // DONE
{
	// Not taking into account the D_in path as we are not using it in this assignment
	if (select_path) // If select path is high, output = x in
	{
		q_out = x_in.read();
	}
	else if (!select_path)
	{
		q_out = z_in.read();
	}
}

// Logic describing the Register File behaviour
void RegisterFile::my_RegisterFile() // DONE
{

	if(wr_en)
	{
		dest = wr_dest.read();
		registers[dest] = wr_data.read();
	}
	else
	{
		Xregister = sel_x.read();	
		Zregister = sel_z.read();
		
		x_out = registers[Xregister];	
		z_out = registers[Zregister];
	}
}

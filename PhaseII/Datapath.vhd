-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.0 Build 156 04/24/2013 SJ Web Edition"
-- CREATED		"Mon May 04 19:03:48 2015"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Datapath IS 
	PORT
	(
		wr_en_rf 		:  IN  	STD_LOGIC;
		PC_ld_reg 		:  IN 	STD_LOGIC;
		CLK 				:  IN  	STD_LOGIC;
		RST 				:  IN  	STD_LOGIC;
		mux_B_sel 		:  IN  	STD_LOGIC;
		wr_en_datamem 	:  IN  	STD_LOGIC;
		alu_op 			:  IN  	STD_LOGIC_VECTOR(1 DOWNTO 0);
		mux_A_sel 		:  IN  	STD_LOGIC_VECTOR(1 DOWNTO 0);
		mux_PC_sel 		:  IN  	STD_LOGIC_VECTOR(1 DOWNTO 0);
		x_sel 			:  IN  	STD_LOGIC_VECTOR(3 DOWNTO 0);
		z_sel				:  IN  	STD_LOGIC_VECTOR(3 DOWNTO 0);
		wr_addr_rf 		:  IN  	STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		dpcr_en			:	IN 	STD_LOGIC; 											--DPCR enable port
		dpcr_out			:	OUT 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		dprr_en			:	IN 	STD_LOGIC; 	
		dprr_in			:	IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		
		clr_eot			: 	IN 	STD_LOGIC;
		eot_en			: 	IN 	STD_LOGIC;
		eot_out			: 	OUT 	STD_LOGIC;
		eot_in			: 	IN 	STD_LOGIC;
		
		clr_er			: 	IN 	STD_LOGIC;
		er_en				:	IN 	STD_LOGIC;
		er_in				: 	IN 	STD_LOGIC;
		er_out			: 	OUT 	STD_LOGIC;
		
		instruction 	:  OUT  	STD_LOGIC_VECTOR(15 DOWNTO 0);
		mux_dm_sel 		: 	IN 	STD_LOGIC_VECTOR(1 downto 0);
		mux_dmr_sel		: 	IN 	STD_LOGIC;
		mux_dmw_sel 	: 	IN 	STD_LOGIC;
		mux_dpcr_sel 	: 	IN 	STD_LOGIC_VECTOR(1 downto 0);
		ir_sel 			: 	IN 	STD_LOGIC;
		ir_en				: 	IN 	STD_LOGIC;
		mux_rf_sel 		: 	IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		en_sip			:	IN 	STD_LOGIC;
		en_sop			:	IN 	STD_LOGIC;
		en_svop			:	IN 	STD_LOGIC;
		SIP_IN			:	IN 	STD_LOGIC_VECTOR(15 DOWNTO 0) ;
		SOP_OUT			:	OUT 	STD_LOGIC_VECTOR(15 DOWNTO 0) ;
		SVOP_OUT			:	OUT 	STD_LOGIC_VECTOR(15 DOWNTO 0) ;
		z_en				: 	IN 	STD_LOGIC;
		clr_z				: 	IN 	STD_LOGIC;
		z_ext_out		: 	OUT 	STD_LOGIC
	);
END Datapath;

ARCHITECTURE bdf_type OF Datapath IS 

COMPONENT alu
	PORT( A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 alu_op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Z : OUT STD_LOGIC;
		 alu_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_32
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_1bit
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 input : IN STD_LOGIC;
		 output : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mux4
	PORT(In0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT data_mem
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rdaddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2
	PORT(Sel : IN STD_LOGIC;
		 In0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT instruction_register
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 sel : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT prog_mem
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 rdaddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pcplus1
	PORT(Input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT max
	PORT(A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 max_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT single_register
	PORT(clk : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT rf
	PORT(clock : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Sel_X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Sel_Z : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 wraddress : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Out_X : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Out_Z : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Out_R7	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux8
	PORT(In0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In3 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In4 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In5 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In6 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 In7 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	CLK_OUT 	:  STD_LOGIC;
SIGNAL	DPCR 		:  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	IReg 		:  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	PC_out 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	RX_OUT 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	RZ_OUT 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL 	const_0 			: 	STD_LOGIC_VECTOR(15 downto 0) := x"0000";
SIGNAL 	const_1 			: 	STD_LOGIC_VECTOR(15 downto 0) := x"0001";
SIGNAL 	const_logic_0 	: 	STD_LOGIC := '0';
SIGNAL 	r_seven			:	STD_LOGIC_VECTOR(15 downto 0);
SIGNAL	zout 				:  STD_LOGIC;
SIGNAL	dprr_out : STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 

b2v_ALU_inst : alu
PORT MAP( A => SYNTHESIZED_WIRE_16,
		 alu_op => alu_op,
		 B => SYNTHESIZED_WIRE_17,
		 Z => zout,
		 alu_out => SYNTHESIZED_WIRE_12);


b2v_DCPR_reg : register_32
PORT MAP(clk => CLK_OUT,
			enable => dpcr_en,
			reset => RST,
		 input => DPCR,
		 output => dpcr_out);
		 
b2v_DPRR_reg : register_32
PORT MAP(clk => CLK_OUT,
			enable => dprr_en,
			reset => RST,
		 input => dprr_in,
		 output => dprr_out); -- dprr out needs to split into the data and the address which is sent to the data mem
		 
b2v_zero_flag_reg : register_1bit
PORT MAP(clk => CLK_OUT,
			enable => z_en, -- changed 
			reset => clr_z,
		 input => zout,
		 output => z_ext_out);
		 
b2v_er_reg : register_1bit -- register set high by env, once ER signal received, register value set low, EOT is emmitted
PORT MAP(clk => CLK_OUT,
			enable => er_en, -- changed 
			reset => clr_er,
			input => er_in,
			output => er_out);
		 
b2v_eot_reg : register_1bit
PORT MAP(clk => CLK_OUT,
			enable => eot_en, -- changed 
			reset => clr_eot,
			input => eot_in,
			output => eot_out);


b2v_DM_DATA_MUX : mux4
PORT MAP(In0 => RX_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 In2 => PC_out,
		 In3 => const_0,
		 Sel => mux_dm_sel,
		 Output => SYNTHESIZED_WIRE_2);


b2v_DM_inst : data_mem
PORT MAP(clock => CLK_OUT,
		 wren => wr_en_datamem,
		 data => SYNTHESIZED_WIRE_2,
		 rdaddress => SYNTHESIZED_WIRE_3,
		 wraddress => SYNTHESIZED_WIRE_4,
		 q => SYNTHESIZED_WIRE_18);


b2v_DMR_MUX : mux2
PORT MAP(In0 => RX_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 Sel => mux_dmr_sel,
		 Output => SYNTHESIZED_WIRE_3);


b2v_DMW_MUX : mux2
PORT MAP(In0 => RZ_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 Sel => mux_dmw_sel,
		 Output => SYNTHESIZED_WIRE_4);


b2v_DPCR_MUX : mux4
PORT MAP(In0 => RX_OUT,
			In1 => r_seven,
			In2 => const_0,
			In3 => IReg(15 DOWNTO 0),
			Sel => mux_dpcr_sel,
			Output => DPCR(15 DOWNTO 0));


b2v_inst1 : instruction_register
PORT MAP(clk => CLK_OUT,
			enable => ir_en,
			reset => RST,
			sel => ir_sel,
		 input => SYNTHESIZED_WIRE_5,
		 output => IReg);


b2v_inst2 : prog_mem
PORT MAP(clock => CLK_OUT,
			wren => const_logic_0,
			data => const_0,
			wraddress => const_0,
		 rdaddress => PC_out,
		 q => SYNTHESIZED_WIRE_5);


b2v_inst4 : pcplus1
PORT MAP(Input => PC_out,
		 Output => SYNTHESIZED_WIRE_8);


b2v_MAX_inst : max
PORT MAP(A => SYNTHESIZED_WIRE_16,
		 B => SYNTHESIZED_WIRE_17,
		 max_out => SYNTHESIZED_WIRE_13);


b2v_MUX_A : mux4
PORT MAP(In0 => RX_OUT,
		 In1 => IReg(15 DOWNTO 0),
		 In2 => const_1,
		 In3 => const_0 ,			-- FIFO
		 Sel => mux_A_sel,
		 Output => SYNTHESIZED_WIRE_16);


b2v_MUX_B : mux2
PORT MAP(Sel => mux_B_sel,
		 In0 => RZ_OUT,
		 In1 => RX_OUT,
		 Output => SYNTHESIZED_WIRE_17);


b2v_PC_MUX : mux4
PORT MAP(In0 => SYNTHESIZED_WIRE_8,
		 In1 => IReg(15 DOWNTO 0),
		 In2 => RX_OUT,
		 In3 => SYNTHESIZED_WIRE_18,
		 Sel => mux_PC_sel,
		 Output => SYNTHESIZED_WIRE_10);


b2v_PC_REGISTER : single_register
PORT MAP(clk => CLK_OUT,
		 enable => PC_ld_reg,
		 reset => RST,
		 input => SYNTHESIZED_WIRE_10,
		 output => PC_out);


b2v_RF_inst : rf
PORT MAP(clock => CLK_OUT,
		 wren => wr_en_rf,
		 data => SYNTHESIZED_WIRE_11,
		 Sel_X => x_sel,
		 Sel_Z => z_sel,
		 wraddress => wr_addr_rf,
		 Out_X => RX_OUT,
		 Out_R7 => r_seven,
		 Out_Z => RZ_OUT);


b2v_RF_MUX : mux8
PORT MAP(In0 => IReg(15 DOWNTO 0),
		 In1 => RX_OUT,
		 In2 => SYNTHESIZED_WIRE_12,
		 In3 => SYNTHESIZED_WIRE_13,
		 In4 => SYNTHESIZED_WIRE_14,
		 In5 => const_0,
		 In6 => SYNTHESIZED_WIRE_18,
		 In7 => const_0,
		 Sel => mux_rf_sel,
		 Output => SYNTHESIZED_WIRE_11);


b2v_SIP : single_register
PORT MAP(clk => CLK_OUT,
			enable => en_sip,
			reset => RST,
			input => SIP_IN,
		 output => SYNTHESIZED_WIRE_14);


b2v_SOP : single_register
PORT MAP(clk => CLK_OUT,
			enable => en_sop,
			reset => RST,
			output => SOP_OUT,
		 input => RX_OUT);


b2v_SVOP : single_register
PORT MAP(clk => CLK_OUT,
			enable => en_svop,
			reset => RST,
			output => SVOP_OUT,
		 input => RX_OUT);

CLK_OUT <= CLK;
instruction(15 DOWNTO 0) <= IReg(31 DOWNTO 16);

END bdf_type;
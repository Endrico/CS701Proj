-- Copyright (C) 1991-2012 Altera Corporation
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

-- PROGRAM		"Quartus II 32-bit"
-- VERSION		"Version 12.0 Build 263 08/02/2012 Service Pack 2 SJ Web Edition"
-- CREATED		"Fri May 08 11:28:55 2015"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Processor IS 
	PORT
	(
		ER 				:  IN  STD_LOGIC;
		CLK 			:  IN  STD_LOGIC;
		RST 			:  IN  STD_LOGIC;
		nios_input 		:  IN  STD_LOGIC;
		debug_hold 		:  IN  STD_LOGIC;
		start_hold 		:  IN  STD_LOGIC;
		start 			:  IN  STD_LOGIC;
		lddprr_done 	:  INOUT  STD_LOGIC;
		dpc_jop 		:  OUT  STD_LOGIC;
		dprr_in 		:  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		FFMR 			:  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		FLMR 			:  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		head_pointer	:  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		SIPi 			:  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		tail_pointer	:  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		Load_Ir 		:  OUT  STD_LOGIC;
		clrirq 			:  INOUT  STD_LOGIC;
		eotout 			:  OUT  STD_LOGIC;
		erout 			:  OUT  STD_LOGIC;
		dpcrout 		:  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		out_sop 		:  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		out_svop 		:  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END Processor;

ARCHITECTURE bdf_type OF Processor IS 

COMPONENT controlunit
	PORT(CLK 			:	IN 	STD_LOGIC;
		 RST_L 			: 	IN 	STD_LOGIC;
		 nios_control 	: 	IN 	STD_LOGIC;
		 debug_hold 	: 	IN 	STD_LOGIC;
		 start_hold 	: 	IN 	STD_LOGIC;
		 start 			: 	IN 	STD_LOGIC;
		 zout, rzout 	: 	IN 	STD_LOGIC;		-- added rzout
		 ld_dprr_done 	: 	INOUT STD_LOGIC;
		 DPC 			:	OUT 	STD_LOGIC;
		 CLR_IRQ		:	INOUT 	STD_LOGIC;
		 DPRR 			: 	IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 FFMR 			: 	IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 FLMR 			: 	IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 HP 			: 	INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 I_code 		: 	IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 TP 			: 	IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 en_z 			: 	OUT STD_LOGIC;
		 dpcr_en 		: 	OUT STD_LOGIC;
		 dprr_en 		: 	OUT STD_LOGIC;
		 ld_IR 			: 	OUT STD_LOGIC;
		 clrz 			: 	OUT STD_LOGIC;
		 clrer 			: 	OUT STD_LOGIC;
		 clreot 		: 	OUT STD_LOGIC;
		 seteot 		: 	OUT STD_LOGIC;
		 wr_en 			: 	OUT STD_LOGIC;
		 sel_ir 		: 	OUT STD_LOGIC;
		 ER_Ld_Reg 		: 	OUT STD_LOGIC;
		 SIP_Ld_Reg 	: 	OUT STD_LOGIC;
		 SOP_Ld_Reg 	: 	OUT STD_LOGIC;
		 SVOP_Ld_Reg 	: 	OUT STD_LOGIC;
		 mux_B_sel 		: 	OUT STD_LOGIC;
		 PC_reg_ld 		: 	OUT STD_LOGIC;
		 data_write 	: 	OUT STD_LOGIC;
		 mux_DMR_sel 	: 	OUT STD_LOGIC;
		 mux_DMW_sel 	: 	OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 alu_op 		: 	OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 DPCR_mux_sel 	: 	OUT STD_LOGIC;
		 mux_A_sel 		: 	OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mux_DM_Data_sel: 	OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mux_PC_sel 	: 	OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mux_RF_sel 	: 	OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 sel_x 			: 	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 sel_z 			: 	OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 wr_dest 		: 	OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT datapath
	PORT(wr_en_rf 		: 	IN	STD_LOGIC;
		 PC_ld_reg 		: 	IN	STD_LOGIC;
		 CLK 			: 	IN	STD_LOGIC;
		 RST 			: 	IN	STD_LOGIC;
		 mux_B_sel 		: 	IN 	STD_LOGIC;
		 wr_en_datamem 	: 	IN 	STD_LOGIC;
		 dpcr_en 		: 	IN 	STD_LOGIC;
		 irq_dm_data	:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 irq_dm_addr	:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 clr_eot 		: 	IN 	STD_LOGIC;
		 eot_en 		: 	IN 	STD_LOGIC;
		 eot_in 		: 	IN 	STD_LOGIC;
		 clr_er 		: 	IN 	STD_LOGIC;
		 er_en 			: 	IN 	STD_LOGIC;
		 er_in 			: 	IN 	STD_LOGIC;
		 mux_dmr_sel 	: 	IN 	STD_LOGIC;
		 mux_dmw_sel 	:	IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ir_sel 		: 	IN 	STD_LOGIC;
		 ir_en 			: 	IN 	STD_LOGIC;
		 en_sip 		: 	IN 	STD_LOGIC;
		 en_sop 		: 	IN 	STD_LOGIC;
		 en_svop 		: 	IN 	STD_LOGIC;
		 z_en 			: 	IN 	STD_LOGIC;
		 clr_z 			: 	IN 	STD_LOGIC;
		 alu_op		 	: 	IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dprr_en 		: 	IN 	STD_LOGIC;
		 dprr_output	:	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dprr_in 		: 	IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_A_sel 		: 	IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mux_dm_sel 	:	IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mux_dpcr_sel 	: 	IN 	STD_LOGIC;
		 mux_PC_sel 	: 	IN 	STD_LOGIC_VECTOR(1 DOWNTO 0);
		 mux_rf_sel 	: 	IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		 SIP_IN 		: 	IN 	STD_LOGIC_VECTOR(15 DOWNTO 0);
		 wr_addr_rf 	: 	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		 x_sel 			: 	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		 z_sel 			: 	IN 	STD_LOGIC_VECTOR(3 DOWNTO 0);
		 eot_out, rz_out_cu : OUT STD_LOGIC;				-- added rz_out_cu
		 er_out 		: 	OUT STD_LOGIC;
		 z_ext_out 		: 	OUT STD_LOGIC;
		 dpcr_out 		: 	OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 instruction 	: 	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SOP_OUT 		: 	OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SVOP_OUT 		: 	OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	a_sel_mux 		:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	clock 			:  STD_LOGIC;
SIGNAL	dm_data_sel_mux :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	dmr_sel_mux 	:  STD_LOGIC;
SIGNAL	dmw_sel_mux 	:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	eot_clr 		:  STD_LOGIC;
SIGNAL	eot_set 		:  STD_LOGIC;
SIGNAL	er_clr 			:  STD_LOGIC;
SIGNAL	Instructions 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	ir_sel 			:  STD_LOGIC;
SIGNAL	ld_dpcr 		:  STD_LOGIC;
SIGNAL	ld_dprr 		:  STD_LOGIC;
SIGNAL	ld_er_reg 		:  STD_LOGIC;
SIGNAL	ld_pc_reg 		:  STD_LOGIC;
SIGNAL	ld_sip_reg 		:  STD_LOGIC;
SIGNAL	ld_sop_reg 		:  STD_LOGIC;
SIGNAL	ld_svop_reg 	:  STD_LOGIC;
SIGNAL	ld_z 			:  STD_LOGIC;
SIGNAL	Load_Ir_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	op_alu 			:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	out_z 			:  STD_LOGIC;
SIGNAL	pc_sel_mux 		:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	reset 			:  STD_LOGIC;
SIGNAL	rf_sel_mux 		:  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	rf_wr_dest 		:  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	rf_wr_en 		:  STD_LOGIC;
SIGNAL	rf_x_sel 		:  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	rf_z_sel 		:	STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sel_dpcr_mux 	:  STD_LOGIC;
SIGNAL	sel_mux_b 		:  STD_LOGIC;
SIGNAL	write_data_dm_en :  STD_LOGIC;
SIGNAL	z_clr, rz_out_signal :  STD_LOGIC;
SIGNAL	dprr_out_sig		:	STD_LOGIC_VECTOR(31 DOWNTO 0);		-- added 13/05/2015
SIGNAL	irqAddr			:	STD_LOGIC_VECTOR(15 DOWNTO 0); 

SIGNAL 	const_0 			: 	STD_LOGIC_VECTOR(31 downto 0) := x"00000000";

BEGIN 

b2v_ControlUnit : controlunit
PORT MAP(CLK => clock,
		 RST_L => reset,
		 DPRR => dprr_out_sig,						-- DPRR added
		 nios_control => nios_input,
		 debug_hold => debug_hold,
		 start_hold => start_hold,
		 start => start,
		 zout => out_z,
		 ld_dprr_done => lddprr_done,
		 DPC => dpc_jop,							-- Read the output of the DPC register
		 CLR_IRQ => clrirq,					-- added 13/05/2015
		 FFMR => FFMR,
		 FLMR => FLMR,
		 HP => head_pointer,
		 I_code => Instructions,
		 TP => tail_pointer,
		 en_z => ld_z,
		 dpcr_en => ld_dpcr,
		 dprr_en => ld_dprr,				-- enable the dprr register to be loaded
		 ld_IR => Load_Ir_ALTERA_SYNTHESIZED,
		 clrz => z_clr,
		 clrer => er_clr,
		 clreot => eot_clr,
		 seteot => eot_set,
		 wr_en => rf_wr_en,
		 sel_ir => ir_sel,
		 ER_Ld_Reg => ld_er_reg,
		 SIP_Ld_Reg => ld_sip_reg,
		 SOP_Ld_Reg => ld_sop_reg,
		 SVOP_Ld_Reg => ld_svop_reg,
		 mux_B_sel => sel_mux_b,
		 PC_reg_ld => ld_pc_reg,
		 data_write => write_data_dm_en,
		 mux_DMR_sel => dmr_sel_mux,
		 mux_DMW_sel => dmw_sel_mux,
		 alu_op => op_alu,
		 DPCR_mux_sel => sel_dpcr_mux,
		 mux_A_sel => a_sel_mux,
		 mux_DM_Data_sel => dm_data_sel_mux,
		 mux_PC_sel => pc_sel_mux,
		 mux_RF_sel => rf_sel_mux,
		 sel_x => rf_x_sel,
		 sel_z => rf_z_sel,
		 wr_dest => rf_wr_dest,
		 rzout => rz_out_signal						-- added for rz out
		 );


b2v_Datapath : datapath
PORT MAP(
		 irq_dm_data =>	irqAddr,					--"000000000000000" & dprr_out_sig(0),
		 irq_dm_addr =>	dprr_out_sig(17 DOWNTO 2),
		 wr_en_rf => rf_wr_en,
		 PC_ld_reg => ld_pc_reg,
		 CLK => clock,
		 RST => reset,
		 mux_B_sel => sel_mux_b,
		 wr_en_datamem => write_data_dm_en,
		 dpcr_en => ld_dpcr,
		 clr_eot => eot_clr,
		 eot_en => eot_set,
		 eot_in => eot_set,
		 clr_er => er_clr,
		 er_en => ld_er_reg,
		 er_in => ER,
		 mux_dmr_sel => dmr_sel_mux,
		 mux_dmw_sel => dmw_sel_mux,
		 ir_sel => ir_sel,
		 ir_en => Load_Ir_ALTERA_SYNTHESIZED,
		 en_sip => ld_sip_reg,
		 en_sop => ld_sop_reg,
		 en_svop => ld_svop_reg,
		 z_en => ld_z,
		 clr_z => z_clr,
		 alu_op => op_alu,
		 dprr_en => ld_dprr,				-- enable the dprr
		 dprr_in => dprr_in,				-- dprr input to the datapath
		 dprr_output => dprr_out_sig,			-- output from the dprr register which needs to be split
		 mux_A_sel => a_sel_mux,
		 mux_dm_sel => dm_data_sel_mux,
		 mux_dpcr_sel => sel_dpcr_mux,
		 mux_PC_sel => pc_sel_mux,
		 mux_rf_sel => rf_sel_mux,
		 SIP_IN => SIPi,
		 wr_addr_rf => rf_wr_dest,
		 x_sel => rf_x_sel,
		 z_sel => rf_z_sel,
		 eot_out => eotout,
		 er_out => erout,
		 z_ext_out => out_z,
		 dpcr_out => dpcrout,
		 instruction => Instructions,
		 SOP_OUT => out_sop,
		 SVOP_OUT => out_svop,
		 rz_out_cu => rz_out_signal					-- added for rz out
		 );
irqAddr <= "000000000000000" & dprr_out_sig(0);
Load_Ir <= Load_Ir_ALTERA_SYNTHESIZED;
--dpc_jop <= dprr_out_sig(1); --can't set dpc here, it is an output from the control unit
clock <= CLK;
reset <= RST;

END bdf_type;
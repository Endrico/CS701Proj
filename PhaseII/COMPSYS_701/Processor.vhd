-- Copyright (C) 1991-2011 Altera Corporation
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
-- VERSION		"Version 11.0 Build 208 07/03/2011 Service Pack 1 SJ Full Version"
-- CREATED		"Wed May 06 14:57:57 2015"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Processor IS 
	PORT
	(	CLK 				:  IN  	STD_LOGIC;
		RST 				:  IN  	STD_LOGIC;
		DPRR				:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
		ER					:	IN		STD_LOGIC;
		SIPi				:	IN		STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		CLR_IRQ			:	OUT	STD_LOGIC;
		EOT				:	OUT	STD_LOGIC;
		DPC				:	OUT	STD_LOGIC;
		DPCR				:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		SOPi				:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		SVOPi				:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0)
		

	);
END Processor;

ARCHITECTURE bdf_type OF Processor IS 

COMPONENT Datapath
	PORT
	(
		wr_en_rf 		:  IN  	STD_LOGIC;
		PC_ld_reg 		:  IN 	STD_LOGIC;
		CLK 				:  IN  	STD_LOGIC;
		RST 				:  IN  	STD_LOGIC;
		mux_B_sel 		:  IN  	STD_LOGIC;
		wr_en_datamem 			:  IN  	STD_LOGIC;
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
END COMPONENT;

COMPONENT CONTROLUNIT
	PORT
	(
	CLK, RST_L, nios_control, debug_hold, start_hold, start : IN STD_LOGIC;
	zout : IN STD_LOGIC;
	I_code : IN STD_LOGIC_VECTOR(15 downto 0);

	--mem_sel, WE : OUT STD_LOGIC;
	ld_IR, clrz, clrer, clreot, seteot, wr_en 		: OUT STD_LOGIC;
	ER_Ld_Reg, SIP_Ld_Reg, SOP_Ld_Reg, SVOP_Ld_Reg 	: OUT STD_LOGIC;
	mux_B_sel, PC_reg_ld, data_write 					: OUT STD_LOGIC;
	mux_DMR_sel, mux_DMW_sel 								: OUT STD_LOGIC;

	alu_op, mux_A_sel, mux_PC_sel 						: OUT STD_LOGIC_VECTOR(1 downto 0);
	mux_DM_Data_sel 											: OUT STD_LOGIC_VECTOR(1 downto 0);
	mux_RF_sel 													: OUT STD_LOGIC_VECTOR(2 downto 0);
	sel_x, sel_z, wr_dest 									: OUT STD_LOGIC_VECTOR(3 downto 0);

	CLR_IRQ 														: OUT STD_LOGIC;
	ld_dprr_done, DPC, IRQ 									: INOUT STD_LOGIC;
	HP 															: INOUT STD_LOGIC_VECTOR(15 downto 0);
	TP 															: IN STD_LOGIC_VECTOR(15 downto 0);
	FLMR 															: IN STD_LOGIC_VECTOR(15 downto 0);
	FFMR 															: IN STD_LOGIC_VECTOR(15 downto 0)
);
END COMPONENT;



BEGIN 





END bdf_type;
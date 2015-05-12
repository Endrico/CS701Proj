library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY CONTROLUNIT IS
	PORT
	(
	CLK, RST_L, nios_control, debug_hold, start_hold, start : IN STD_LOGIC;
	zout, rzout : IN STD_LOGIC;
	I_code : IN STD_LOGIC_VECTOR(15 downto 0);

	--mem_sel, WE : OUT STD_LOGIC;
	en_z, dpcr_en, dprr_en		:	OUT STD_LOGIC; -- need to assign
	ld_IR, clrz, clrer, clreot, seteot, wr_en, sel_ir: OUT STD_LOGIC;
	ER_Ld_Reg, SIP_Ld_Reg, SOP_Ld_Reg, SVOP_Ld_Reg : OUT STD_LOGIC;
	mux_B_sel, PC_reg_ld, data_write : OUT STD_LOGIC;
	mux_DMR_sel, mux_DMW_sel, DPCR_mux_sel : OUT STD_LOGIC;

	alu_op, mux_A_sel, mux_PC_sel : OUT STD_LOGIC_VECTOR(1 downto 0);
	mux_DM_Data_sel : OUT STD_LOGIC_VECTOR(1 downto 0);
	mux_RF_sel : OUT STD_LOGIC_VECTOR(2 downto 0);
	sel_x, sel_z, wr_dest : OUT STD_LOGIC_VECTOR(3 downto 0);

	CLR_IRQ : OUT STD_LOGIC;
	ld_dprr_done, DPC, IRQ : INOUT STD_LOGIC;
	HP : INOUT STD_LOGIC_VECTOR(15 downto 0);
	TP : IN STD_LOGIC_VECTOR(15 downto 0);
	FLMR : IN STD_LOGIC_VECTOR(15 downto 0);
	FFMR : IN STD_LOGIC_VECTOR(15 downto 0)
);
END CONTROLUNIT;

ARCHITECTURE bhvr OF CONTROLUNIT IS
	type CU_STATE IS (Init, TEST, TEST2, E0, E1, E1bis, E2, T0, T1, T2, T3);
	signal STATE, NEXT_STATE : CU_STATE := Init;
	signal AM : STD_LOGIC_VECTOR(1 downto 0);
	signal OPCODE : STD_LOGIC_VECTOR(5 downto 0);
	signal RX : STD_LOGIC_VECTOR(3 downto 0);
	signal RZ : STD_LOGIC_VECTOR(3 downto 0);
	signal LOCK : STD_LOGIC := 0;

	-- Addressing mode bits
	constant Inherent_AM  : std_logic_vector(1 downto 0) := "00";
	constant Immediate_AM : std_logic_vector(1 downto 0) := "01";
	constant Direct_AM    : std_logic_vector(1 downto 0) := "10";
	constant Register_AM  : std_logic_vector(1 downto 0) := "11";
	-- Instruction Opcodes
	constant AND_I        : std_logic_vector(5 downto 0) := "001000";
	constant OR_I         : std_logic_vector(5 downto 0) := "001100";
	constant ADD_I        : std_logic_vector(5 downto 0) := "111000";
	constant SUBV_I       : std_logic_vector(5 downto 0) := "000011";
	constant SUB_I        : std_logic_vector(5 downto 0) := "000100";
	constant LDR_I        : std_logic_vector(5 downto 0) := "000000";
	constant STR_I        : std_logic_vector(5 downto 0) := "000010";
	constant JMP_I        : std_logic_vector(5 downto 0) := "011000";
	constant PRESENT_I    : std_logic_vector(5 downto 0) := "011100";
	constant DCALLBL_I    : std_logic_vector(5 downto 0) := "101000";
	constant DCALLNB_I    : std_logic_vector(5 downto 0) := "101001";
	constant SZ_I         : std_logic_vector(5 downto 0) := "010100";
	constant CLFZ_I       : std_logic_vector(5 downto 0) := "010000";
	constant CER_I        : std_logic_vector(5 downto 0) := "111100";
	constant CEOT_I       : std_logic_vector(5 downto 0) := "111110";
	constant SEOT_I       : std_logic_vector(5 downto 0) := "111111";
	constant LER_I        : std_logic_vector(5 downto 0) := "110110";
	constant SSVOP_I      : std_logic_vector(5 downto 0) := "111011";
	constant LSIP_I       : std_logic_vector(5 downto 0) := "110111";
	constant SSOP_I       : std_logic_vector(5 downto 0) := "111010";
	constant NOOP_I       : std_logic_vector(5 downto 0) := "110100";
	constant MAX_I        : std_logic_vector(5 downto 0) := "011110";
	constant STRPC_I      : std_logic_vector(5 downto 0) := "011101";

BEGIN
	AM <= I_code(15 downto 14);
	OPCODE <= I_code(13 downto 8);
	RZ <= I_code(7 downto 4);
	RX <= I_code(3 downto 0);
	Process(CLK)
	BEGIN
		IF(RST_L = '1') THEN
			STATE <= Init;
		-- all outputs set to default
		ELSIF CLK='1' and CLK'event THEN
			CASE STATE IS
				WHEN Init =>
					IF(debug_hold = '1') THEN
						STATE <= TEST;
					ELSE
						STATE <= E0;
					END IF;
				WHEN TEST =>
				WHEN TEST2 =>
				WHEN E0 =>
					IF(DPC = '1' AND IRQ = '1') THEN
						STATE <= E1;
					ELSIF(DPC = '0' AND IRQ = '0') THEN
						STATE <= E2;
					ELSE
						STATE <= T0;
					END IF;
				WHEN E1 =>
					STATE <= E1bis;
				WHEN E1bis =>
					IF(debug_hold = '1') THEN
						STATE <= TEST;
					ELSE
						STATE <= E0;
					END IF;
				WHEN E2 =>
					IF(unsigned(HP) - unsigned(TP) = 0) THEN
						STATE <= T0;
					ELSIF(debug_hold = '1') THEN
						STATE <= TEST;
					ELSE
						STATE <= E0;
					END IF;
				WHEN T0 =>
					STATE <= T1;
				WHEN T1 =>
					STATE <= T2;
				WHEN T2 =>
					IF(LOCK = '1') THEN
						IF(ld_dprr_done = '0') THEN
							IF(debug_hold = '1') THEN
								STATE <= TEST;
							ELSE
								STATE <= E0;
							END IF;
						ELSE
							STATE <= T2;
						END IF;
					ELSIF(debug_hold = '1') THEN
						STATE <= TEST;
					ELSE
						STATE <= E0;
					END IF;
				WHEN T3 =>
				WHEN OTHERS =>
					STATE <= Init;
			END CASE;
		END IF;
	END Process;

	Process(STATE, AM, OPCODE,RX,RZ)
	BEGIN
		CASE STATE IS
			WHEN Init =>
				wr_en <= '0';
				ld_IR <= '0';
				sel_ir <= '0';					-- added
				PC_reg_ld <= '0';
				ER_Ld_Reg <= '0';
				SIP_Ld_Reg <= '0';
				SVOP_Ld_Reg <= '0';
				SOP_Ld_Reg <= '0';
				clrz <= '0';
				clrer <= '0';
				clreot <= '0';
				seteot <= '0';
				data_write <= '0';
				mux_PC_sel <= "00";
			WHEN E0 =>
				en_z <='0';						-- Added 12/05/2015
				wr_en <= '0';
				ld_IR <= '0';
				sel_ir <= '0';					-- added
				PC_reg_ld <= '0';				-- changed from 1 12/05
				ER_Ld_Reg <= '0';
				SIP_Ld_Reg <= '0';
				SVOP_Ld_Reg <= '0';
				SOP_Ld_Reg <= '0';
				dpcr_en <= '0';
				clrz <= '0';
				clrer <= '0';
				clreot <= '0';
				seteot <= '0';
				data_write <= '0';
				IF(DPC = '1' AND IRQ = '1') THEN
					-- R15 <= M[HP](7..0)
				ELSIF(DPC = '0' AND IRQ = '0') THEN
					IF(ld_dprr_done = '1') THEN
						CLR_IRQ <= '0';
					END IF;
				ELSE
					IF(IRQ = '0' AND ld_dprr_done = '1') THEN
						CLR_IRQ <= '0';
					END IF;
				END IF;
			WHEN E1 =>
				-- MR[R15] <= DPRR
					--dprr_en <= '1';			-- added to ld dprr register
					--sel_x <= "1110";		-- added to select R15 so its contents is the memory address.
					--mux_DMR_sel <= "";
					
			WHEN E1bis =>
				IF(unsigned(HP) - unsigned(FLMR) /= 0) THEN
					HP <= std_logic_vector(unsigned(HP) + 1);
				ELSE
					HP <= FFMR;
				END IF;
				DPC <= '0';
				IRQ <= '0';
				CLR_IRQ <= '1';
				ld_dprr_done <= '0';
			WHEN E2 =>
				IF(unsigned(HP) - unsigned(TP) /= 0) THEN
					DPC <= '1';
					ld_dprr_done <= '1';
				ELSE
					IF(IRQ = '0' AND ld_dprr_done = '1') THEN
						CLR_IRQ <= '1';
					END IF;
				END IF;
			WHEN T0 =>
				ld_IR <= '1';
				sel_ir <= '1';				-- Added
				mux_PC_sel <= "00";
				PC_reg_ld <= '1';			-- changed from 0 12/05
			WHEN T1 =>
				CASE AM IS
					WHEN Inherent_AM =>
						ld_IR <= '0';
						PC_reg_ld <= '0';
					WHEN Immediate_AM =>
						ld_IR <= '1';
						sel_ir <= '0';			-- added
						mux_PC_sel <= "00";
						PC_reg_ld <= '1';		-- changed 12/05/2015
					WHEN Direct_AM =>
						ld_IR <= '1';
						sel_ir <= '0';			-- added
						mux_PC_sel <= "00";
						PC_reg_ld <= '1';		-- changed 12/05/2015
					WHEN Register_AM =>
						ld_IR <= '0';
						PC_reg_ld <= '0';
					WHEN OTHERS =>
				END CASE;
				CASE OPCODE IS
					WHEN LER_I =>
						ER_Ld_Reg <= '1';
					WHEN LSIP_I =>
						SIP_Ld_Reg <= '1';
					WHEN PRESENT_I =>	-- dont think we need any of this
						en_z <= '1';		--changed from clrz
						sel_z <= RZ;
					WHEN OTHERS =>
				END CASE;
			WHEN T2 =>
				ld_IR <= '0';
				PC_reg_ld <= '0';
				CASE AM IS
					WHEN Inherent_AM =>
						CASE OPCODE IS
							WHEN CLFZ_I =>
								clrz <= '1';
							WHEN CER_I =>
								clrer <= '1';
							WHEN CEOT_I =>
								clreot <= '1';
							WHEN SEOT_I =>
								seteot <= '1';
							WHEN NOOP_I =>
							WHEN OTHERS =>
						END CASE;
					WHEN Immediate_AM =>
						CASE OPCODE IS
							WHEN AND_I =>
								alu_op <= "10";
								sel_x <= RX;
								mux_A_sel <= "01";
								mux_B_sel <= '1';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN OR_I =>
								alu_op <= "11";
								sel_x <= RX;
								mux_A_sel <= "01";
								mux_B_sel <= '1';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN ADD_I =>
								alu_op <= "00";
								sel_x <= RX;
								mux_A_sel <= "01";
								mux_B_sel <= '1';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN SUBV_I =>
								alu_op <= "01";
								sel_x <= RX;
								mux_A_sel <= "01";
								mux_B_sel <= '1';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN SUB_I =>
								alu_op <= "01";
								sel_x <= RX;
								mux_A_sel <= "01";
								mux_B_sel <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN LDR_I =>
								mux_RF_sel <= "000";
								wr_dest <= Rz;
								wr_en <= '1';
								sel_ir <= '0';			-- added because bottom ir not loading in properly
							WHEN STR_I =>
								mux_DMW_sel <= '0';
								mux_DM_Data_sel <= "01";
								data_write <= '1';
							WHEN JMP_I =>
								mux_PC_sel <= "01";
								PC_reg_ld <= '1';
							WHEN PRESENT_I =>		-- need to have it read the port where rzout comes in and checks if it is Zero not zout from alu. ie bypass alu
								clrz <= '0';
								IF(rzout = '1') THEN
									mux_PC_sel <= "01";
									PC_reg_ld <= '1';
								END IF;
							WHEN DCALLBL_I =>
								-- TODO
								--DPCR <- Rx & Operand
								IF(LOCK = '0' AND DPC = '0') THEN
									DPCR_mux_sel <= '1';			-- sel in1
									dpcr_en <= '1';
									DPC <= '1';
									LOCK <= '1';
									ld_dprr_done <= '1';
								ELSIF(LOCK = '1' AND IRQ = '1') THEN
									wr_dest <= x"0";
									wr_en <= '1';
									mux_RF_sel <= "111"; -- TODO check if this is connected correctly
									ld_dprr_done <= '0';
									DPC <= '0';
									-- dpcr_clr <= '1'; -- TODO add clr to dpcr mux
								END IF;
							WHEN DCALLNB_I =>
								-- TODO
								--DPCR <- Rx & Operand
								DPCR_mux_sel <= '1';			-- sel in1
								dpcr_en <= '1';
							WHEN SZ_I =>
								IF(zout = '1') THEN
									mux_PC_sel <= "01";
									PC_reg_ld <= '1';
								END IF;
							WHEN MAX_I =>
								sel_x <= RX;
								mux_A_sel <= "01";
								mux_B_sel <= '1';
								mux_RF_sel <= "011";
								wr_dest <= RZ;
								wr_en <= '1';
							WHEN OTHERS =>
						END CASE;
					WHEN Direct_AM =>
						CASE OPCODE IS
							WHEN LDR_I =>
								mux_DMR_sel <= '1';
								mux_RF_sel <= "110";
								wr_dest <= RZ;
								wr_en <= '1';
								sel_ir <= '0';				-- Added because bottom ir was not loading in properly
							WHEN STR_I =>
								mux_DMW_sel <= '1';
								mux_DM_Data_sel <= "00";
								data_write <= '1';
							WHEN STRPC_I =>
								mux_DMW_sel <= '1';
								mux_DM_Data_sel <= "10";
								data_write <= '1';
							WHEN OTHERS =>
						END CASE;
					WHEN Register_AM =>
						CASE OPCODE IS
							WHEN AND_I =>
								alu_op <= "10";
								sel_x <= RX;
								sel_z <= RZ;
								mux_A_sel <= "00";
								mux_B_sel <= '0';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN OR_I =>
								alu_op <= "11";
								sel_x <= RX;
								sel_z <= RZ;
								mux_A_sel <= "00";
								mux_B_sel <= '0';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN ADD_I =>
								alu_op <= "00";
								sel_x <= RX;
								sel_z <= RZ;
								mux_A_sel <= "00";
								mux_B_sel <= '0';
								mux_RF_sel <= "010";
								wr_dest <= RZ;
								wr_en <= '1';
								en_z <='1';			-- Added 12/05/2015
							WHEN LDR_I =>
								sel_x <= RX;
								mux_RF_sel <= "001";
								wr_dest <= Rz;
								wr_en <= '1';
								sel_ir <= '0';			-- added because bottom ir not loading in properly
							WHEN STR_I =>
								sel_x <= RX;
								mux_DMW_sel <= '0';
								mux_DM_Data_sel <= "00";
								data_write <= '1';
							WHEN JMP_I =>
								sel_x <= RX;
								mux_PC_sel <= "11";
								PC_reg_ld <= '1';
							WHEN DCALLBL_I =>
								-- TODO
								--DPCR <- R7 & Rx
								IF(LOCK = '0' AND DPC = '0') THEN
									DPCR_mux_sel <= '0';			-- sel in0
									dpcr_en <= '1';
									DPC <= '1';
									LOCK <= '1';
									ld_dprr_done <= '1';
								ELSIF(LOCK = '1' AND IRQ = '1') THEN
									wr_dest <= x"0";
									wr_en <= '1';
									mux_RF_sel <= "111"; -- TODO check if this is connected correctly
									ld_dprr_done <= '0';
									DPC <= '0';
									-- dpcr_clr <= '1'; -- TODO add clr to dpcr mux
								END IF;
							WHEN DCALLNB_I =>
								-- TODO
								--DPCR <- R7 & Rx
								DPCR_mux_sel <= '0';			-- sel in0
								dpcr_en <= '1';
							WHEN LER_I =>
								mux_RF_sel <= "101";
								wr_dest <= RZ;
								wr_en <= '1';
							WHEN SSVOP_I =>
								sel_x <= RX;
								SVOP_Ld_Reg <= '1';
							WHEN LSIP_I =>
								mux_RF_sel <= "100";
								wr_dest <= RZ;				--"0001";
								wr_en <= '1';
							WHEN SSOP_I =>
								sel_x <= RX;
								SOP_Ld_Reg <= '1';
							WHEN OTHERS =>
						END CASE;
					WHEN OTHERS =>
				END CASE;
				ld_dprr_done <= '1';
			WHEN T3 =>
			WHEN OTHERS =>
		END CASE;
	END Process;
END ARCHITECTURE bhvr;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY CONTROLUNIT IS
  PORT
  (
  CLK, RST_L, nios_control, debug_hold, start : IN STD_LOGIC;
  zout : IN STD_LOGIC;
  I_code : IN STD_LOGIC_VECTOR(15 downto 0);

  mem_sel, WE : OUT STD_LOGIC;
  ld_IR, clrz, clrer, clreot, seteot, wr_en : OUT STD_LOGIC;
  ER_Ld_Reg, SIP_Ld_Reg, SOP_Ld_Reg, SVOP_Ld_Reg : OUT STD_LOGIC;
  mux_B_sel, PC_reg_ld, data_write : OUT STD_LOGIC;
  mux_DMR_sel, mux_DMW_sel : OUT STD_LOGIC;

  alu_op, mux_A_sel, mux_PC_sel : OUT STD_LOGIC_VECTOR(1 downto 0);
  mux_RF_sel, mux_DM_Data_sel : OUT STD_LOGIC_VECTOR(1 downto 0);
  sel_x, sel_z, wr_dest : OUT STD_LOGIC_VECTOR(3 downto 0)
);
END CONTROLUNIT;

ARCHITECTURE bhvr OF CONTROLUNIT IS
  type CU_STATE IS (Init, E0, E1, E1bis, E2, T0, T1, T2, T3);
  signal STATE, NEXT_STATE : CU_STATE := Init;

  -- Addressing mode bits
  constant Inherent_AM  : std_logic_vector(1 downto 0) := "00";
  constant Immediate_AM : std_logic_vector(1 downto 0) := "00";
  constant Direct_AM    : std_logic_vector(1 downto 0) := "00";
  constant Register_AM  : std_logic_vector(1 downto 0) := "00";
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
  Process(CLK, RST_L)
  BEGIN
  END Process;

  Process(CLK, RST_L)
  BEGIN
    IF(RST_L = '1') THEN
      STATE <= Init;
      -- all outputs set to default
    ELSIf CLK='1' and CLK'event THEN
      CASE STATE IS
        WHEN Init =>
          STATE <= E0;
        WHEN E0 =>
          wr_en <= 0;
          ld_IR <= 0;
          PC_reg_ld <= 0;
          ER_Ld_Reg <= 0;
          SIP_Ld_Reg <= 0;
          SVOP_Ld_Reg <= 0;
          SOP_Ld_Reg <= 0;
          clrz <= 0;
          clrer <= 0;
          clreot <= 0;
          seteot <= 0;
          data_write <= 0;

        WHEN E1 =>
        WHEN E1bis =>
        WHEN E2 =>
        WHEN T0 =>
        WHEN T1 =>
        WHEN T2 =>
        WHEN T3 =>
        WHEN OTHERS =>
          STATE <= Init;
      END CASE;
    END IF;
  END Process;
END ARCHITECTURE bhvr;


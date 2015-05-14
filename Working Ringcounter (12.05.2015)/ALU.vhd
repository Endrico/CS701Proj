library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY ALU IS
	PORT
	(
		alu_op : IN STD_LOGIC_VECTOR(1 downto 0);
		A, B : IN STD_LOGIC_VECTOR(15 downto 0);
		alu_out : OUT STD_LOGIC_VECTOR(15 downto 0);
		Z : OUT STD_LOGIC := '0'
	);
END ALU;

ARCHITECTURE bhvr OF ALU IS
	signal add_op : STD_LOGIC_VECTOR(15 downto 0);
	signal sub_op : STD_LOGIC_VECTOR(15 downto 0);
	signal and_op : STD_LOGIC_VECTOR(15 downto 0);
	signal or_op : STD_LOGIC_VECTOR(15 downto 0);
	signal tmp_out : STD_LOGIC_VECTOR(15 downto 0);
	signal tmp_z: STD_LOGIC := '0';
BEGIN
	add_op <= A + B;
	sub_op <= B - A;
	and_op <= A and B;
	or_op <= A or B;
	tmp_out <= add_op when alu_op = "00" else
			   sub_op when alu_op = "01" else
			   and_op when alu_op = "10" else
			   or_op;
	tmp_z <= '1' when tmp_out = x"0000" else
			 '0';
	alu_out <= tmp_out;
	Z <= tmp_z;
end ARCHITECTURE bhvr;


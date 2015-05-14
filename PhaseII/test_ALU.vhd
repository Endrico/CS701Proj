library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY test_ALU IS
end entity test_ALU;

ARCHITECTURE bhvr of test_ALU is
	signal t_clrz, t_Z : STD_LOGIC;
	signal t_alu_op : STD_LOGIC_VECTOR(1 downto 0);
	signal t_A, t_B, t_out : STD_LOGIC_VECTOR(15 downto 0);

	component ALU IS
	PORT
	(
		clrz : IN STD_LOGIC := '0';
		alu_op : IN STD_LOGIC_VECTOR(1 downto 0);
		A, B : IN STD_LOGIC_VECTOR(15 downto 0);
		alu_out : OUT STD_LOGIC_VECTOR(15 downto 0);
		Z : OUT STD_LOGIC := '0'
	);
	END component;
begin
	t_ALU : ALU port map(t_clrz, t_alu_op, t_A, t_B, t_out, t_Z);

	init: process
	begin
		t_clrz <= '0', '1' after 2 ns, '0' after 5 ns;
		wait;
	end process init;

	test_bench: process
	begin
		wait for 5 ns;
		t_A <= x"0004";
		t_B <= x"0006";
		t_alu_op <= "00";
		wait for 5 ns;
		t_A <= x"0002";
		t_B <= x"0008";
		t_alu_op <= "01";
		wait for 5 ns;
		t_A <= "0001000101010001";
		t_B <= "0001010000010101";
		t_alu_op <= "10";
		wait for 5 ns;
		t_A <= "0000010100000001";
		t_B <= "0001000000000101";
		t_alu_op <= "11";
		wait for 5 ns;
		t_A <= x"000C";
		t_B <= x"000C";
		t_alu_op <= "01";
		wait for 5 ns;
		t_A <= x"0007";
		t_B <= x"000A";
		t_alu_op <= "00";
		wait for 5 ns;
	end process test_bench;
end ARCHITECTURE bhvr;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY test_MAX IS
end entity test_MAX;

ARCHITECTURE bhvr of test_MAX is
	signal t_A, t_B, t_out : STD_LOGIC_VECTOR(15 downto 0);

	component MAX IS
	PORT
	(
		A, B : IN STD_LOGIC_VECTOR(15 downto 0);
		max_out : OUT STD_LOGIC_VECTOR(15 downto 0)
	);
	END component;
begin
	t_MAX : MAX port map(t_A, t_B, t_out);

	test_bench: process
	begin
		wait for 5 ns;
		t_A <= x"0004";
		t_B <= x"0006";
		wait for 5 ns;
		t_A <= x"F002";
		t_B <= x"0008";
		wait for 5 ns;
		t_A <= x"0B02";
		t_B <= x"0C08";
		wait for 5 ns;
		t_A <= x"FEDC";
		t_B <= x"CEDF";
		wait for 5 ns;
		t_A <= x"FABC";
		t_B <= x"ABCF";
	end process test_bench;
end ARCHITECTURE bhvr;



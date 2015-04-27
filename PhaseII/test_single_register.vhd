library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY test_single_register IS
end entity test_single_register;

ARCHITECTURE bhvr of test_single_register is
	signal t_CLK, t_en, t_RST : STD_LOGIC;
	signal t_in, t_out : STD_LOGIC_VECTOR(15 downto 0);

	component single_register IS
	PORT
	(
		clk	:	in	std_logic;
		enable:	in	std_logic;
		reset	:	in std_logic;
		input	:	in std_logic_vector(15 downto 0);
		output:	out std_logic_vector(15 downto 0)
	);
	END component;
begin
	t_single_register : single_register port map(t_clk, t_en, t_RST, t_in, t_out);

	clock: process
	begin
		t_clk <= '1';
		wait for 5 ns;
		t_clk <= '0';
		wait for 5 ns;
	end process clock;

	test_bench: process
	begin
		wait for 10 ns;
		t_en <= '1';
		t_in <= x"0404";
		wait for 10 ns;
		t_en <= '0';
		t_in <= x"0652";
		wait for 10 ns;
		t_en <= '1';
		t_in <= x"FFFF";
		wait for 10 ns;
		t_en <= '1';
		t_in <= x"CBCB";
		wait for 10 ns;
		t_en <= '1';
		t_rst <= '1';
		t_in <= x"A7A7";
		wait for 10 ns;
		t_en <= '1';
		t_rst <= '0';
		t_in <= x"8123";
		wait for 10 ns;
		t_en <= '1';
		t_rst <= '1';
		t_in <= x"8346";
		wait for 10 ns;
		t_en <= '0';
		t_rst <= '0';
		t_in <= x"9761";
		wait for 10 ns;
		t_en <= '1';
		t_rst <= '1';
		t_in <= x"9763";
		wait for 10 ns;
		t_en <= '0';
		t_rst <= '1';
		t_in <= x"9761";
	end process test_bench;
end ARCHITECTURE bhvr;


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY instruction_register is port(
	clk	:	in	std_logic;
	enable:	in	std_logic;
	reset	:	in std_logic;
	sel	:	in std_logic;
	input	:	in std_logic_vector(15 downto 0);
	output:	out std_logic_vector(31 downto 0)
	
);
END instruction_register;

architecture behaviour of instruction_register is
	signal tmp_top, tmp_bot : std_logic_vector(15 downto 0);
begin 
	process(clk)
		begin
			if (clk = '1' and clk'event) then
				if (reset = '1') then
					tmp_top <= x"0000";
					tmp_bot <= x"0000";  -- x stands for hexidecimal 16 bits lonf  therefor four zeros
				elsif (enable = '1' and sel = '1') then
					tmp_top <= input;
					tmp_bot <= x"0000";
				elsif (enable = '1' and sel = '0') then
					tmp_bot <= input;
				end if;
			end if;
	end process;
	output<= tmp_top & tmp_bot;
end behaviour; 
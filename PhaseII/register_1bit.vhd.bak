library ieee;
use ieee.std_logic_1164.all; 

ENTITY register_1bit is port(
	clk	:	in	std_logic;
	enable:	in	std_logic;
	reset	:	in std_logic;
	input	:	in std_logic;
	output:	out std_logic;
	
);
END register_1bit;

architecture behaviour of register_1bit is
begin 
	process(clk)
		begin
			if (clk = '1' and clk'event) then
				if (reset = '1') then
					output <= 0;  -- x stands for hexidecimal 16 bits lonf  therefor four zeros
				elsif (enable = '1') then
					output <= input;
				end if;
			end if;
	end process;
end behaviour; 


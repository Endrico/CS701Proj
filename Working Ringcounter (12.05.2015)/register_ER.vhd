library ieee;
use ieee.std_logic_1164.all; 

ENTITY register_ER is port(
	clk	:	in	std_logic;
	enable:	in	std_logic;
	reset	:	in std_logic;
	input	:	in std_logic;
	output:	out std_logic_vector(15 downto 0)
	
);
END register_ER;

architecture behaviour of register_ER is
begin 
	process(clk)
		begin
			if (clk = '1' and clk'event) then
				if (reset = '1') then
					output <= x"0000";  -- x stands for hexidecimal 16 bits lonf  therefor four zeros
				elsif (enable = '1') then
					output <= "000000000000000" & input;
				end if;
			end if;
	end process;
end behaviour; 


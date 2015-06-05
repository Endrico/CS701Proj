library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;
use work.jop_config_global.all;
use work.jop_config.all;

entity por is
	port (
		
		clk     : in    std_logic;
		reset   : out   std_logic
		
	);
end entity;

architecture rtl of por is
	
	signal res_cnt : unsigned(2 downto 0) := "000";
	
	attribute altera_attribute : string;
	
	attribute altera_attribute of res_cnt : signal is "POWER_UP_LEVEL=LOW";
	
begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			if res_cnt /= "111" then
				res_cnt <= res_cnt + 1;
			end if;
			
			reset <= not res_cnt(0) or not res_cnt(1) or not res_cnt(2);
		end if;
	end process;
	
end architecture;

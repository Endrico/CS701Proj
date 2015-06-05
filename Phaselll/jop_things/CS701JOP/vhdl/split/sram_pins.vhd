library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;
use work.jop_config_global.all;
use work.jop_config.all;

entity sram_pins is
	port (
		
		ram_addr    : in    std_logic_vector(19 downto 0);
		ram_dout    : in    std_logic_vector(15 downto 0);
		ram_din     : out   std_logic_vector(15 downto 0);
		ram_dout_en : in    std_logic;
		ram_ncs     : in    std_logic;
		ram_noe     : in    std_logic;
		ram_nwe     : in    std_logic;
		
		SRAM_ADDR   : out   std_logic_vector(19 downto 0);
		SRAM_DQ     : inout std_logic_vector(15 downto 0);
		SRAM_CE_N   : out   std_logic;
		SRAM_OE_N   : out   std_logic;
		SRAM_WE_N   : out   std_logic;
		SRAM_UB_N   : out   std_logic;
		SRAM_LB_N   : out   std_logic
		
	);
end entity;

architecture rtl of sram_pins is
begin
	
	process(ram_dout_en, ram_dout)
	begin
		if ram_dout_en = '1' then
			SRAM_DQ <= ram_dout;
		else
			SRAM_DQ <= (others => 'Z');
		end if;
	end process;
	
	ram_din <= SRAM_DQ;
	
	SRAM_ADDR <= ram_addr;
	SRAM_CE_N <= ram_ncs;
	SRAM_OE_N <= ram_noe;
	SRAM_WE_N <= ram_nwe;
	SRAM_UB_N <= '0';
	SRAM_LB_N <= '0';
	
end architecture;

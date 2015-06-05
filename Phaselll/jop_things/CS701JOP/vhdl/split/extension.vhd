library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;

entity extension is
	port (
		
		clk         : in    std_logic;
		reset       : in    std_logic;
		
		mmu_instr   : in    std_logic_vector(MMU_WIDTH-1 downto 0);
		mul_dout    : in    std_logic_vector(31 downto 0);
		mem_out     : in    mem_out_type;
		wr_dly      : in    std_logic;
		
		exr         : out   std_logic_vector(31 downto 0);
		bsy         : out   std_logic
		
	);
end entity;

architecture rtl of extension is
begin
	
	process(clk, reset)
	begin
		if reset = '1' then
			exr <= (others => '0');
		elsif rising_edge(clk) then
			
			if mmu_instr = LDMRD then
				exr <= mem_out.dout;
			elsif mmu_instr = LDMUL then
				exr <= mul_dout;
			else
				exr <= mem_out.bcstart;
			end if;
			
		end if;
	end process;
	
	bsy <= wr_dly or mem_out.bsy;
	
end architecture;

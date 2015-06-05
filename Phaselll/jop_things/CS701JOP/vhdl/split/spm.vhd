library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;

entity spm is
	generic (
		
		spm_width : integer := 0
		
	);
	port (
		
		clk             : in    std_logic;
		
		sc_scratch_out  : in    sc_out_type;
		sc_scratch_in   : out   sc_in_type
		
	);
end entity;

architecture rtl of spm is
begin
	
	--
	-- Generate scratchpad memory when size is != 0.
	-- Results in warnings when the size is 0.
	--
	sc1: if spm_width /= 0 generate
		scm: entity work.sdpram
		generic map (
			width       => 32,
			addr_width  => spm_width
		)
		port map (
			wrclk       => clk,
			data        => sc_scratch_out.wr_data,
			wraddress   => sc_scratch_out.address(spm_width-1 downto 0),
			wren        => sc_scratch_out.wr,
			rdclk       => clk,
			rdaddress   => sc_scratch_out.address(spm_width-1 downto 0),
			rden        => sc_scratch_out.rd,
			dout        => sc_scratch_in.rd_data
		);
	end generate;
	
	sc_scratch_in.rdy_cnt <= (others => '0');
	
end architecture;

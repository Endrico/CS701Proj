library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;

entity sc_select is
	port (
		
		sc_ctrl_mem_out : in    sc_out_type;
		sc_mem_out      : out   sc_out_type;
		sc_scratch_out  : out   sc_out_type;
		sc_io_out       : out   sc_out_type
		
	);
end entity;

architecture rtl of sc_select is
	
	signal mem_access       : std_logic;
	signal scratch_access   : std_logic;
	signal io_access        : std_logic;
	
begin
	
	process(sc_ctrl_mem_out)
	begin
		
		mem_access <= '0';
		scratch_access <= '0';
		io_access <= '0';
		
		case sc_ctrl_mem_out.address(SC_ADDR_SIZE-1 downto SC_ADDR_SIZE-2) is
		when "10" =>
			scratch_access <= '1';
		when "11" =>
			io_access <= '1';
		when others =>
			mem_access <= '1';
		end case;
		
	end process;
	
	sc_mem_out.address          <= sc_ctrl_mem_out.address;
	sc_mem_out.wr_data          <= sc_ctrl_mem_out.wr_data;
	sc_mem_out.rd               <= sc_ctrl_mem_out.rd and mem_access;
	sc_mem_out.wr               <= sc_ctrl_mem_out.wr and mem_access;
	sc_mem_out.atomic           <= sc_ctrl_mem_out.atomic;
	sc_mem_out.cache            <= sc_ctrl_mem_out.cache;
	sc_mem_out.cinval           <= sc_ctrl_mem_out.cinval;
	sc_mem_out.tm_cache         <= sc_ctrl_mem_out.tm_cache;
	sc_mem_out.tm_broadcast     <= sc_ctrl_mem_out.tm_broadcast;
	
	sc_scratch_out.address      <= sc_ctrl_mem_out.address;
	sc_scratch_out.wr_data      <= sc_ctrl_mem_out.wr_data;
	sc_scratch_out.rd           <= sc_ctrl_mem_out.rd and scratch_access;
	sc_scratch_out.wr           <= sc_ctrl_mem_out.wr and scratch_access;
	sc_scratch_out.atomic       <= sc_ctrl_mem_out.atomic;
	sc_scratch_out.cache        <= sc_ctrl_mem_out.cache;
	sc_scratch_out.cinval       <= sc_ctrl_mem_out.cinval;
	sc_scratch_out.tm_cache     <= sc_ctrl_mem_out.tm_cache;
	sc_scratch_out.tm_broadcast <= sc_ctrl_mem_out.tm_broadcast;
	
	sc_io_out.address           <= sc_ctrl_mem_out.address;
	sc_io_out.wr_data           <= sc_ctrl_mem_out.wr_data;
	sc_io_out.rd                <= sc_ctrl_mem_out.rd and io_access;
	sc_io_out.wr                <= sc_ctrl_mem_out.wr and io_access;
	sc_io_out.atomic            <= sc_ctrl_mem_out.atomic;
	sc_io_out.cache             <= sc_ctrl_mem_out.cache;
	sc_io_out.cinval            <= sc_ctrl_mem_out.cinval;
	sc_io_out.tm_cache          <= sc_ctrl_mem_out.tm_cache;
	sc_io_out.tm_broadcast      <= sc_ctrl_mem_out.tm_broadcast;
	
end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;

entity sc_read is
	port (
		
		clk             : in    std_logic;
		reset           : in    std_logic;
		
		sc_ctrl_mem_out : in    sc_out_type;
		
		sc_mem_in       : in    sc_in_type;
		sc_scratch_in   : in    sc_in_type;
		sc_io_in        : in    sc_in_type;
		sc_ctrl_mem_in  : out   sc_in_type
		
	);
end entity;

architecture rtl of sc_read is
	
	signal sc_ctrl_mem_in_s : sc_in_type;
	
	signal next_mux_mem     : std_logic_vector(1 downto 0);
	signal dly_mux_mem      : std_logic_vector(1 downto 0);
	signal mux_mem          : std_logic_vector(1 downto 0);
	signal is_pipelined     : std_logic;
	
begin
	
	process(clk, reset)
	begin
		if reset = '1' then
			next_mux_mem <= (others => '0');
			dly_mux_mem <= (others => '0');
			is_pipelined <= '0';
		elsif rising_edge(clk) then
			
			if sc_ctrl_mem_out.rd='1' or sc_ctrl_mem_out.wr='1' then
				next_mux_mem <= sc_ctrl_mem_out.address(SC_ADDR_SIZE-1 downto SC_ADDR_SIZE-2);
				dly_mux_mem <= next_mux_mem;
				if sc_ctrl_mem_in_s.rdy_cnt = "01" then
					is_pipelined <= '1';
				end if;
			end if;
			
			if sc_ctrl_mem_in_s.rdy_cnt = "00" then
				is_pipelined <= '0';
			end if;
			
		end if;
	end process;
	
	process(next_mux_mem, is_pipelined, dly_mux_mem, mux_mem, sc_scratch_in, sc_io_in, sc_mem_in)
	begin
		
		mux_mem <= next_mux_mem;
		if is_pipelined='1' then
			mux_mem <= dly_mux_mem;
		end if;
		
		case mux_mem is
		when "10" =>
			sc_ctrl_mem_in_s <= sc_scratch_in;
		when "11" =>
			sc_ctrl_mem_in_s <= sc_io_in;
		when others =>
			sc_ctrl_mem_in_s <= sc_mem_in;
		end case;
		
	end process;
	
	sc_ctrl_mem_in <= sc_ctrl_mem_in_s;
	
end architecture;

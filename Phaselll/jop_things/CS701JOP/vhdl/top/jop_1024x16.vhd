--
--
--  This file is a part of JOP, the Java Optimized Processor
--
--  Copyright (C) 2001-2008, Martin Schoeberl (martin@jopdesign.com)
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/>.
--


--
--	jop_1024x16.vhd
--
--	top level for a 1024x16 SRAM board (e.g. Altera DE2-115 board)
--
--	2013-08-27	adapted from jop_512x32.vhd
--
--


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;
use work.jop_config_global.all;
use work.jop_config.all;


entity jop is

generic (				
	ram_cnt		: integer := 2;		-- clock cycles for external ram
    --rom_cnt	: integer := 3;		-- clock cycles for external rom OK for 20 MHz
    rom_cnt		: integer := 15;	-- clock cycles for external rom for 100 MHz
	jpc_width	: integer := 13;	-- address bits of java bytecode pc = cache size
	block_bits	: integer := 5;		-- 2*block_bits is number of cache blocks
	spm_width	: integer := 0		-- size of scratchpad RAM (in number of address bits for 32-bit words)
);

port (
	CLOCK_50				: in std_logic;
	
--
--	LEDs
--
	LEDR		: out std_logic_vector(17 downto 0);
	LEDG		: out std_logic_vector(8 downto 0);
	
	GPIOi		: in std_logic_vector(15 downto 0);
	GPIOo 	: out std_logic_vector(15 downto 0);
	GPIO_zero : out std_logic_vector(19 downto 0);
	
--
--	Switches
--
	SW				: in std_logic_vector(17 downto 0);
	
--
--	serial interface
--
	UART_TXD			: out std_logic;
	UART_RXD			: in std_logic;
	UART_CTS		: in std_logic;
	UART_RTS		: out std_logic;
	
-- 
-- seven segment display dog
--
HEX0 : out std_logic_vector( 6 downto 0);
HEX2 : out std_logic_vector( 6 downto 0);
HEX3 : out std_logic_vector( 6 downto 0);
HEX4 : out std_logic_vector( 6 downto 0);
HEX5 : out std_logic_vector( 6 downto 0);
HEX6 : out std_logic_vector( 6 downto 0);
HEX7 : out std_logic_vector( 6 downto 0);
HEX1 : out std_logic_vector( 6 downto 0);

	
--
--	only one ram bank
--
	SRAM_ADDR	 : out std_logic_vector(19 downto 0);
	SRAM_DQ		 : inout std_logic_vector(15 downto 0);
	SRAM_CE_N	 : out std_logic;
	SRAM_OE_N	 : out std_logic;
	SRAM_WE_N	 : out std_logic;
	SRAM_UB_N	 : out std_logic;
	SRAM_LB_N	 : out std_logic
);
end jop;

architecture rtl of jop is

--
--	components:
--

component pll is
generic (multiply_by : natural; divide_by : natural);
port (
	inclk0		: in std_logic;
	c0			: out std_logic;
	c1			: out std_logic;
	locked		: out std_logic
);
end component;


--
--	Signals
--
	signal clk_int			: std_logic;

	signal int_res			: std_logic;
	signal res_cnt			: unsigned(2 downto 0) := "000";	-- for the simulation

	attribute altera_attribute : string;
	attribute altera_attribute of res_cnt : signal is "POWER_UP_LEVEL=LOW";

--
--	jopcpu connections
--
	signal sc_mem_out		: sc_out_type;
	signal sc_mem_in		: sc_in_type;
	signal sc_io_out		: sc_out_type;
	signal sc_io_in			: sc_in_type;
	signal irq_in			: irq_bcf_type;
	signal irq_out			: irq_ack_type;
	signal exc_req			: exception_type;

--
--	IO interface
--
	signal ser_in			: ser_in_type;
	signal ser_out			: ser_out_type;
	signal wd_out			: std_logic;

	-- for generation of internal reset
-- memory interface

	signal ram_addr			: std_logic_vector(19 downto 0);
	signal ram_dout			: std_logic_vector(15 downto 0);
	signal ram_din			: std_logic_vector(15 downto 0);
	signal ram_dout_en		: std_logic;
	signal ram_ncs			: std_logic;
	signal ram_noe			: std_logic;
	signal ram_nwe			: std_logic;

-- not available at this board:
	signal ser_ncts			: std_logic;
	signal ser_nrts			: std_logic;
	
-- remove the comment for RAM access counting
-- signal ram_count		: std_logic;

begin

	--ser_ncts <= '0';
--
--	intern reset
--	no extern reset, epm7064 has too less pins
--

process(clk_int)
begin
	if rising_edge(clk_int) then
		if (res_cnt/="111") then
			res_cnt <= res_cnt+1;
		end if;

		int_res <= not res_cnt(0) or not res_cnt(1) or not res_cnt(2);
	end if;
end process;

--
--	components of jop
--
	pll_inst : pll generic map(
		multiply_by => pll_mult,
		divide_by => pll_div
	)
	port map (
		inclk0	 => CLOCK_50,
		c0	 => clk_int
	);
-- clk_int <= clk;

	LEDG(8) <= wd_out;
	GPIO_zero <= (others => '0');
	cpu: entity work.jopcpu
		generic map(
			jpc_width => jpc_width,
			block_bits => block_bits,
			spm_width => spm_width
		)
		port map(clk_int, int_res,
			sc_mem_out, sc_mem_in,
			sc_io_out, sc_io_in,
			irq_in, irq_out, exc_req);

	io: entity work.scio 
		port map (clk_int, int_res,
			sc_io_out, sc_io_in,
			irq_in, irq_out, exc_req,

			txd => UART_TXD,
			rxd => UART_RXD,
			ncts => UART_CTS,
			nrts => UART_RTS,
			
-- this are the things for 7 seg connected to the simcon dog

		HEX0_out		=>	HEX0 ,
		HEX1_out		=>	HEX1 ,
		HEX2_out		=>	HEX2 ,
		HEX3_out		=>	HEX3 ,
		HEX4_out		=>	HEX4 ,
		HEX5_out		=>	HEX5 ,
		HEX6_out		=>	HEX6 ,
		HEX7_out		=>	HEX7 ,
			
			oLEDR => LEDR,
--			oLEDG => LEDG,
			iSW => SW,
			GP_IN => GPIOi,
			GP_OUT => GPIOo,
			
			wd => wd_out,
			--- IO pins
			l => open,
			r => open,
			t => open,
			b => open
			-- remove the comment for RAM access counting
			-- ram_cnt => ram_count
			

		);

	scm: entity work.sc_mem_if
		generic map (
			ram_ws => ram_cnt-1,
			addr_bits => 20
		)
		port map (clk_int, int_res,
			sc_mem_out, sc_mem_in,

			ram_addr => ram_addr,
			ram_dout => ram_dout,
			ram_din => ram_din,
			ram_dout_en	=> ram_dout_en,
			ram_ncs => ram_ncs,
			ram_noe => ram_noe,
			ram_nwe => ram_nwe
		);

	process(ram_dout_en, ram_dout)
	begin
		if ram_dout_en='1' then
			SRAM_DQ <= ram_dout;
		else
			SRAM_DQ <= (others => 'Z');
		end if;
	end process;

	ram_din <= SRAM_DQ;
	
	-- remove the comment for RAM access counting
	-- ram_count <= ram_ncs;

--
--	To put this RAM address in an output register
--	we have to make an assignment (FAST_OUTPUT_REGISTER)
--
	SRAM_ADDR <= ram_addr;
	SRAM_CE_N <= ram_ncs;
	SRAM_OE_N <= ram_noe;
	SRAM_WE_N <= ram_nwe;
	SRAM_UB_N <= '0';
	SRAM_LB_N <= '0';

end rtl;

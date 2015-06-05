library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;
--use work.jop_config_global.all;
use work.jop_config.all;

entity jop is
	generic (
		
		ram_cnt     : integer := 2;
		rom_cnt     : integer := 15;
		jpc_width   : integer := 12;
		block_bits  : integer := 5;
		spm_width   : integer := 0
		
	);
	port (
		
		CLOCK_50    : in    std_logic;
		
		LEDR        : out   std_logic_vector(17 downto 0);
		LEDG        : out   std_logic_vector(8 downto 0);
		SW          : in    std_logic_vector(17 downto 0);
		
		UART_TXD    : out   std_logic;
		UART_RXD    : in    std_logic;
		UART_CTS    : in    std_logic;
		UART_RTS    : out   std_logic;
		
		SRAM_ADDR   : out   std_logic_vector(19 downto 0);
		SRAM_DQ     : inout std_logic_vector(15 downto 0);
		SRAM_CE_N   : out   std_logic;
		SRAM_OE_N   : out   std_logic;
		SRAM_WE_N   : out   std_logic;
		SRAM_UB_N   : out   std_logic;
		SRAM_LB_N   : out   std_logic
		
	);
end entity;

architecture rtl of jop is
	
	signal clk              : std_logic;
	signal reset            : std_logic;
	
	signal sc_ctrl_mem_out  : sc_out_type;
	signal sc_mem_out       : sc_out_type;
	signal sc_scratch_out   : sc_out_type;
	signal sc_io_out        : sc_out_type;
	
	signal sc_ctrl_mem_in   : sc_in_type;
	signal sc_mem_in        : sc_in_type;
	signal sc_scratch_in    : sc_in_type;
	signal sc_io_in         : sc_in_type;
	
	signal irq_in           : irq_bcf_type;
	signal irq_out          : irq_ack_type;
	signal exc_req          : exception_type;
	
	signal ram_addr         : std_logic_vector(19 downto 0);
	signal ram_dout         : std_logic_vector(15 downto 0);
	signal ram_din          : std_logic_vector(15 downto 0);
	signal ram_dout_en      : std_logic;
	signal ram_ncs          : std_logic;
	signal ram_noe          : std_logic;
	signal ram_nwe          : std_logic;
	
begin
	
	pll: entity work.pll
	generic map (
		multiply_by => pll_mult,
		divide_by   => pll_div
	)
	port map (
		inclk0  => CLOCK_50,
		c0      => clk
	);
	
	por: entity work.por
	port map (
		clk     => clk,
		reset   => reset
	);
	
	jopcpu: entity work.jopcpu
	generic map (
		jpc_width   => jpc_width,
		block_bits  => block_bits
	)
	port map (
		clk         => clk,
		reset       => reset,
		sc_mem_out  => sc_ctrl_mem_out,
		sc_mem_in   => sc_ctrl_mem_in,
		irq_in      => irq_in,
		irq_out     => irq_out,
		exc_req     => exc_req
	);
	
	sc_select: entity work.sc_select
	port map (
		sc_ctrl_mem_out => sc_ctrl_mem_out,
		sc_mem_out      => sc_mem_out,
		sc_scratch_out  => sc_scratch_out,
		sc_io_out       => sc_io_out
	);
	
	sc_mem_if: entity work.sc_mem_if
	generic map (
		ram_ws      => ram_cnt-1,
		addr_bits   => 20
	)
	port map (
		clk         => clk,
		reset       => reset,
		sc_mem_out  => sc_mem_out,
		sc_mem_in   => sc_mem_in,
		ram_addr    => ram_addr,
		ram_dout    => ram_dout,
		ram_din     => ram_din,
		ram_dout_en => ram_dout_en,
		ram_ncs     => ram_ncs,
		ram_noe     => ram_noe,
		ram_nwe     => ram_nwe
	);
	
	sram_pins: entity work.sram_pins
	port map (
		ram_addr    => ram_addr,
		ram_dout    => ram_dout,
		ram_din     => ram_din,
		ram_dout_en => ram_dout_en,
		ram_ncs     => ram_ncs,
		ram_noe     => ram_noe,
		ram_nwe     => ram_nwe,
		SRAM_ADDR   => SRAM_ADDR,
		SRAM_DQ     => SRAM_DQ,
		SRAM_CE_N   => SRAM_CE_N,
		SRAM_OE_N   => SRAM_OE_N,
		SRAM_WE_N   => SRAM_WE_N,
		SRAM_UB_N   => SRAM_UB_N,
		SRAM_LB_N   => SRAM_LB_N
	);
	
	spm: entity work.spm
	generic map (
		spm_width => spm_width
	)
	port map (
		clk             => clk,
		sc_scratch_out  => sc_scratch_out,
		sc_scratch_in   => sc_scratch_in
	);
	
	scio: entity work.scio
	port map (
		clk         => clk,
		reset       => reset,
		sc_io_out   => sc_io_out,
		sc_io_in    => sc_io_in,
		irq_in      => irq_in,
		irq_out     => irq_out,
		exc_req     => exc_req,
		txd         => UART_TXD,
		rxd         => UART_RXD,
		ncts        => UART_CTS,
		nrts        => UART_RTS,
		oLEDR       => LEDR,
--		oLEDG       => LEDG,
		iSW         => SW,
		wd          => LEDG(8),
		l           => open,
		r           => open,
		t           => open,
		b           => open
	);
	
	sc_read: entity work.sc_read
	port map (
		clk             => clk,
		reset           => reset,
		sc_ctrl_mem_out => sc_ctrl_mem_out,
		sc_mem_in       => sc_mem_in,
		sc_scratch_in   => sc_scratch_in,
		sc_io_in        => sc_io_in,
		sc_ctrl_mem_in  => sc_ctrl_mem_in
	);
	
end architecture;

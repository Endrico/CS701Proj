library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;

entity jopcpu is
	generic (
		
		jpc_width   : integer;
		block_bits  : integer
		
	);
	port (
		
		clk         : in    std_logic;
		reset       : in    std_logic;
		
		sc_mem_out  : out   sc_out_type;
		sc_mem_in   : in    sc_in_type;
		
		irq_in      : in    irq_bcf_type;
		irq_out     : out   irq_ack_type;
		exc_req     : out   exception_type
		
	);
end;

architecture rtl of jopcpu is
	
	signal mem_out          : mem_out_type;
	signal mem_in           : mem_in_type;
	
	signal stack_din        : std_logic_vector(31 downto 0);
	signal stack_tos        : std_logic_vector(31 downto 0);
	signal stack_nos        : std_logic_vector(31 downto 0);
	
	signal bc_wr_addr       : std_logic_vector(jpc_width-3 downto 0);
	signal bc_wr_data       : std_logic_vector(31 downto 0);
	signal bc_wr_ena        : std_logic;
	
	signal mmu_instr        : std_logic_vector(MMU_WIDTH-1 downto 0);
	signal mul_wr           : std_logic;
	signal wr_dly           : std_logic;
	signal mul_dout         : std_logic_vector(31 downto 0);
	signal bsy              : std_logic;
	
	signal stack_overflow   : std_logic;
	signal null_pointer     : std_logic;
	signal bounds_error     : std_logic;
	
begin
	
	core: entity work.core
	generic map (
		jpc_width   => jpc_width
	)
	port map (
		clk         => clk,
		reset       => reset,
		bsy         => bsy,
		din         => stack_din,
		mem_in      => mem_in,
		mmu_instr   => mmu_instr,
		mul_wr      => mul_wr,
		wr_dly      => wr_dly,
		bc_wr_addr  => bc_wr_addr,
		bc_wr_data  => bc_wr_data,
		bc_wr_ena   => bc_wr_ena,
		irq_in      => irq_in,
		irq_out     => irq_out,
		sp_ov       => stack_overflow,
		aout        => stack_tos,
		bout        => stack_nos
	);
	
	mem_sc: entity work.mem_sc
	generic map (
		jpc_width   => jpc_width,
		block_bits  => block_bits
	)
	port map (
		clk         => clk,
		reset       => reset,
		ain         => stack_tos,
		bin         => stack_nos,
		np_exc      => null_pointer,
		ab_exc      => bounds_error,
		mem_in      => mem_in,
		mem_out     => mem_out,
		bc_wr_addr  => bc_wr_addr,
		bc_wr_data  => bc_wr_data,
		bc_wr_ena   => bc_wr_ena,
		sc_mem_out  => sc_mem_out,
		sc_mem_in   => sc_mem_in
	);
	
	mul: entity work.mul
	port map (
		clk     => clk,
		ain     => stack_tos,
		bin     => stack_nos,
		wr      => mul_wr,
		dout    => mul_dout
	);
	
	extension: entity work.extension
	port map (
		clk         => clk,
		reset       => reset,
		mmu_instr   => mmu_instr,
		mul_dout    => mul_dout,
		mem_out     => mem_out,
		wr_dly      => wr_dly,
		exr         => stack_din,
		bsy         => bsy
	);
	
	exception: entity work.exception
	port map (
		stack_overflow  => stack_overflow,
		null_pointer    => null_pointer,
		bounds_error    => bounds_error,
		exc_req         => exc_req
	);
	
end architecture;

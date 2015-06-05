library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jop_types.all;
use work.sc_pack.all;

entity exception is
	port (
		
		stack_overflow  : in    std_logic;
		null_pointer    : in    std_logic;
		bounds_error    : in    std_logic;
		exc_tm_rollback : in    std_logic := '0';
		
		exc_req         : out   exception_type
		
	);
end entity;

architecture rtl of exception is
begin
	
	exc_req.spov        <= stack_overflow;
	exc_req.np          <= null_pointer;
	exc_req.ab          <= bounds_error;
	exc_req.rollback    <= exc_tm_rollback;
	
end architecture;

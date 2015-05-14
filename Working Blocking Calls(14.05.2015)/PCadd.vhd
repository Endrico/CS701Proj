library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PCplus1 is
port(	Input: 	in std_logic_vector(15 downto 0);
	Output:	out std_logic_vector(15 downto 0)
);
end PCplus1;

architecture behavior of PCplus1 is

signal result: std_logic_vector(15 downto 0);
begin
	
	result <= Input + 1;
   Output <= result;
	
end behavior;
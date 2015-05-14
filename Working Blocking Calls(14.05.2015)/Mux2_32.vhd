library ieee;
use ieee.std_logic_1164.all;

entity Mux2_32 is
port(	In1: 	in std_logic_vector(31 downto 0);
	In0: 	in std_logic_vector(31 downto 0);
	Sel:	in std_logic;
	Output:	out std_logic_vector(31 downto 0)
);
end Mux2_32;

architecture behavior of Mux2_32 is
begin

    Output <=	In0 when Sel= '0' else
					In1 when Sel= '1' else
					"ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

end behavior;
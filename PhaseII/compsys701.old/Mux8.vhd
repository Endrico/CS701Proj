library ieee;
use ieee.std_logic_1164.all;

entity Mux8 is
port(	In7: 	in std_logic_vector(15 downto 0);
	In6: 	in std_logic_vector(15 downto 0);
	In5: 	in std_logic_vector(15 downto 0);
	In4: 	in std_logic_vector(15 downto 0);
	In3: 	in std_logic_vector(15 downto 0);
	In2: 	in std_logic_vector(15 downto 0);
	In1: 	in std_logic_vector(15 downto 0);
	In0: 	in std_logic_vector(15 downto 0);
	Sel:	in std_logic_vector(2 downto 0);
	Output:	out std_logic_vector(15 downto 0)
);
end Mux8;

architecture behavior of Mux8 is
begin

    Output <=	In0 when Sel="000" else
		In1 when Sel="001" else
		In2 when Sel="010" else
		In3 when Sel="011" else
		In4 when Sel="100" else
		In5 when Sel="101" else
		In6 when Sel="110" else
		In7 when Sel="111" else
		"ZZZZZZZZZZZZZZZZ";

end behavior;
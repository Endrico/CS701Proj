library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
	port(
	CLK : in std_logic;
	C_Out : out std_logic_vector(13 downto 0)
);
end entity counter;

architecture behv of counter is
	signal v_Q : std_logic_vector(13 downto 0) := (others => '0');
begin
	process(CLK)
	begin
		if(CLK'event and CLK='1') then
			v_Q <= v_Q + 1;
		end if;
		C_Out <= not v_Q;
	end process;
end behv;


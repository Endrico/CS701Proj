Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sevenseg_translator is
   port (
      digit : in std_logic_vector(3 downto 0);
      clear : in std_logic;
      ss_out : out std_logic_vector(6 downto 0));
end entity sevenseg_translator;

architecture description of sevenseg_translator is
   signal ss : std_logic_vector(6 downto 0);
begin
   ss <= "1000000" when digit = "0000" else -- 0
         "1111001" when digit = "0001" else -- 1
         "0100100" when digit = "0010" else -- 2
         "0110000" when digit = "0011" else -- 3
         "0011001" when digit = "0100" else -- 4
         "0010010" when digit = "0101" else -- 5
         "0000010" when digit = "0110" else -- 6
         "1111000" when digit = "0111" else -- 7
         "0000000" when digit = "1000" else -- 8
         "0010000" when digit = "1001" else -- 9
         "0001000" when digit = "1010" else -- A
         "0000011" when digit = "1011" else -- b
         "0100111" when digit = "1100" else -- c
         "0100001" when digit = "1101" else -- d
         "0000110" when digit = "1110" else -- E
         "0001110" when digit = "1111" else -- F
         "1111111";
   ss_out <= ss when (clear = '0') else (others => '1');
end architecture description;
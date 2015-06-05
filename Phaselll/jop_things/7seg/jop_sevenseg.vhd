Library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity jop_sevenseg is
   generic (
   addr_bits : integer );
   port (
      clk : in std_logic;
      reset : in std_logic;
      sc_rd : in std_logic;
      sc_rd_data : out std_logic_vector(31 downto 0);
      sc_wr : in std_logic;
      sc_wr_data : in std_logic_vector(31 downto 0);
      sc_rdy_cnt : out unsigned(1 downto 0);
      sc_addr : in std_logic_vector(addr_bits-1 downto 0);
      
      HEX0 : out std_logic_vector(6 downto 0);
      HEX1 : out std_logic_vector(6 downto 0);
      HEX2 : out std_logic_vector(6 downto 0);
      HEX3 : out std_logic_vector(6 downto 0);
      HEX4 : out std_logic_vector(6 downto 0);
      HEX5 : out std_logic_vector(6 downto 0);
      HEX6 : out std_logic_vector(6 downto 0);
      HEX7 : out std_logic_vector(6 downto 0)
		);
end entity jop_sevenseg;

architecture description of jop_sevenseg is
   signal digits : std_logic_vector(31 downto 0);
   signal clear : std_logic_vector(7 downto 0);
begin
   sst0: entity work.sevenseg_translator port map (
      ss_out => HEX0,
      digit => digits(3 downto 0),
      clear => clear(0)
   );
   
   sst1: entity work.sevenseg_translator port map (
      ss_out => HEX1,
      digit => digits(7 downto 4),
      clear => clear(1)
   );
   
   sst2: entity work.sevenseg_translator port map (
      ss_out => HEX2,
      digit => digits(11 downto 8),
      clear => clear(2)
   );
   
   sst3: entity work.sevenseg_translator port map (
      ss_out => HEX3,
      digit => digits(15 downto 12),
      clear => clear(3)
   );
   
   sst4: entity work.sevenseg_translator port map (
      ss_out => HEX4,
      digit => digits(19 downto 16),
      clear => clear(4)
   );
   
   sst5: entity work.sevenseg_translator port map (
      ss_out => HEX5,
      digit => digits(23 downto 20),
      clear => clear(5)
   );
   
   sst6: entity work.sevenseg_translator port map (
      ss_out => HEX6,
      digit => digits(27 downto 24),
      clear => clear(6)
   );
   
   sst7: entity work.sevenseg_translator port map (
      ss_out => HEX7,
      digit => digits(31 downto 28),
      clear => clear(7)
   );
   
	process(clk, reset)
	begin
		if reset = '1' then
			sc_rd_data <= (others => '0');
			digits <= (others => '0');
         clear <= (others => '1');
		elsif rising_edge(clk) then
			if sc_rd = '1' then
            sc_rd_data <= digits;
         end if;
         if sc_wr = '1' then
            if sc_addr = "0000" then
               digits <= sc_wr_data;
            elsif sc_addr = "0001" then
               clear <= sc_wr_data(7 downto 0);
            end if;
			end if;
		end if;
	end process;
end architecture description;
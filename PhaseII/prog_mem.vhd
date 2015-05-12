--Custom defined memory; much simpler than Altera Megafunction.
--Synchronous reads and writes
--Quartus automatically synthesises as RAM (Modelsim doesn't know the difference)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY prog_mem IS
    PORT
    (
        clock       : IN STD_LOGIC  := '1';
        data        : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        rdaddress       : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        wraddress       : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        wren        : IN STD_LOGIC  := '0';
        q       : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END prog_mem;

ARCHITECTURE behaviour OF prog_mem IS
    type DMEMORY is array(0 to 65535) of std_logic_vector(15 downto 0); --16K Memory
    constant dataInit : DMEMORY := (
  x"3400",x"4010",x"0001", 
  x"4040",x"0010",x"4344",
  x"0001",x"5C40",x"0000",
  x"F811",x"F700",x"CC01",
  x"FA00",x"4030",x"ffff",	-- changed x"4030" x"FFFF" to x"4030" x"0001"
  x"4333",x"0001",x"5C30",
        x"0005", --Address 0
        x"5800", --Address 1
		  x"000F",
        others => x"0000");
    signal DATA_MEM : DMEMORY := dataInit;
BEGIN
    
    memory_access: process(clock)
    begin
        if (clock'event and clock='1') then
            if (wren = '1') then
                DATA_MEM(to_integer(unsigned(wraddress(15 downto 0)))) <= data;
            end if;
        end if;
    end process memory_access;   
	 q <= DATA_MEM(to_integer(unsigned(rdaddress(15 downto 0))));
    
END behaviour;

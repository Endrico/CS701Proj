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
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wraddress		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC  := '0';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END prog_mem;

ARCHITECTURE behaviour OF prog_mem IS
	type DMEMORY is array(0 to 65535) of std_logic_vector(15 downto 0); --16K Memory
	constant dataInit : DMEMORY := (
	--PROGRAM HERE
		others => x"0000");
	signal DATA_MEM : DMEMORY := dataInit;
BEGIN
	
	memory_access: process(clock)
	begin
		if (clock'event and clock='1') then
			if (wren = '1') then
				DATA_MEM(to_integer(unsigned(wraddress(15 downto 0)))) <= data;
			end if;
				q <= DATA_MEM(to_integer(unsigned(rdaddress(15 downto 0))));
		end if;
	end process memory_access;   
	
END behaviour;
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

-- entity declaration for your testbench.Dont declare any ports here
ENTITY test_tb IS 
END test_tb;

ARCHITECTURE behavior OF test_tb IS
   -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT test  --'test' is the name of the module needed to be tested.
--just copy and paste the input and output ports of your module as such. 
    PORT( 
         clk : IN  std_logic;
         count : OUT  std_logic_vector(3 downto 0);
         reset : IN  std_logic
        );
    END COMPONENT;
   --declare inputs and initialize them
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   --declare outputs and initialize them
   signal count : std_logic_vector(3 downto 0);
   -- Clock period definitions
   constant clk_period : time := 1 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
   uut: test PORT MAP (
         clk => clk,
          count => count,
          reset => reset
        );       

   -- Clock process definitions( clock with 50% duty cycle is generated here.
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clk <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;
   -- Stimulus process
  stim_proc: process
   begin         
        wait for 7 ns;
        reset <='1';
        wait for 3 ns;
        reset <='0';
        wait for 17 ns;
        reset <= '1';
        wait for 1 ns;
        reset <= '0';
        wait;
  end process;

END;

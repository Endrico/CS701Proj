library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
LIBRARY work;

entity test_bench is 
end test_bench;

architecture behaviour of test_bench is 
	component Processor
	
	port(
			ER				:  IN  STD_LOGIC;
			CLK			:  IN  STD_LOGIC;
			RST 			:  IN  STD_LOGIC;
			nios_input 	:  IN  STD_LOGIC;
			debug_hold	:  IN  STD_LOGIC;
			start_hold 	:  IN  STD_LOGIC;
			start			:  IN  STD_LOGIC;
			lddprr_done :  INOUT  STD_LOGIC;
			dpc			:  INOUT  STD_LOGIC;
			irq			:  INOUT  STD_LOGIC;
			dprr_in :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
			FFMR :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			FLMR :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			head_pointer :  INOUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			SIPi :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			tail_pointer :  IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			Load_Ir :  OUT  STD_LOGIC;
			clr_irq :  OUT  STD_LOGIC;
			eotout :  OUT  STD_LOGIC;
			erout :  OUT  STD_LOGIC;
			dpcrout :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
			out_sop :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
			out_svop :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
			
		 );
	end component;
	
	signal		ER				:  STD_LOGIC ;
	signal		CLK			:  STD_LOGIC := '0';
	signal		RST 			:  STD_LOGIC := '0';
	signal		nios_input 	:  STD_LOGIC := '0';
	signal		debug_hold	:  STD_LOGIC := '0';
	signal		start_hold 	:  STD_LOGIC := '0';
	signal		start			:  STD_LOGIC := '0';
	signal		lddprr_done : STD_LOGIC := '0';
	signal		dpc			: STD_LOGIC := '1';
	signal		irq			: STD_LOGIC := '0';
	signal		dprr_in 		:  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal		FFMR 			:  STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal		FLMR			:  STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal		head_pointer:   STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal		SIPi			:    STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal		tail_pointer:   STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal		Load_Ir		:  STD_LOGIC := '0';
	signal		clr_irq		:  STD_LOGIC := '0';
	signal		eotout		:  STD_LOGIC := '0';
	signal		erout			:  STD_LOGIC := '0';
	signal		dpcrout		:  STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal		out_sop 		:  STD_LOGIC_VECTOR(15 DOWNTO 0);
	signal		out_svop 	:  STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	constant clk_period : time := 20 ns;
	
BEGIN 

    -- Instantiate the Unit Under Test (UUT)
   uut: processor PORT MAP (
   
		  ER => ER,	
        CLK	=>	CLK,	
	     RST =>	RST,		
        nios_input =>	nios_input,
        debug_hold =>	debug_hold,
        start_hold =>	start_hold,
        start		=>	start,
        lddprr_done => lddprr_done,
        dpc	=> dpc,		
        irq	=> irq,		
        dprr_in => dprr_in,		
        FFMR =>	FFMR,		
        FLMR =>	FLMR,		
        head_pointer  => head_pointer,
        SIPi  => SIPi,			
        tail_pointer => tail_pointer,
        Load_Ir => Load_Ir,		
        clr_irq	=> clr_irq,	
        eotout	=>	eotout,
        erout	=>	erout,	
        dpcrout =>	dpcrout,	
        out_sop =>	out_sop,	
        out_svop =>	out_svop
		  
		  );
		  
 -- Clock process definitions( clock with 50% duty cycle is generated here.
   clk_process :process
   begin
        CLK <= '0';
        wait for 10 ns;  --for 0.5 ns signal is '0'.
        CLK <= '1';
        wait for 10 ns;  --for next 0.5 ns signal is '1'.
   end process;
	
	
   rst_process :process
   begin
		RST <= '0';
		wait for 10 ns; 
        RST <= '1';
        wait for 20 ns;  --for 0.5 ns signal is '0'.
        RST <= '0';
		  wait;
   end process;
   
   start_process :process
   begin
        start <= '0';
        wait for 900 ns;  --for 0.5 ns signal is '0'.
        start <= '1';
		  wait;
   end process;
   
	
	
END;
library ieee;
use ieee.std_logic_1164.all;



entity tb is
end tb;


architecture behavioral of tb is

	signal resetn          : std_logic := '0';
	
--	signal clkA             : std_logic := '0';
--	signal clkB             : std_logic := '0';
    
    signal clk  : std_logic := '0';
    
    signal led_0_r: std_logic; 
    signal led_0_g: std_logic;
    signal led_0_b: std_logic;
    signal led_1_r: std_logic; 
    signal led_1_g: std_logic;
    signal led_1_b: std_logic;
    signal end_cycle: std_logic;
    
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      
	constant period : time := 2*hp; 
	
	constant hpA : time := 2 ns;      
	constant periodA : time := 2*hpA; 
	
	constant hpB : time := 10 ns; 
	constant periodB : time := 2*hpB;
	
	
	--Declaration de l'entite a tester
	component  fsm  
		port ( 
		    clk : in std_logic;
--			clkA	: in std_logic;
--			clkB	: in std_logic; 
			resetn  : in std_logic;
            led_0_r : out std_logic;
            led_0_g : out std_logic;
            led_0_b : out std_logic;
            led_1_r : out std_logic;
            led_1_g : out std_logic;
            led_1_b : out std_logic;
            end_cycle : out std_logic
            
		 );
	end component;
	
	

	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	comp_led: fsm 
        port map (
              clk=>clk,
--            clkA => clkA,
--            clkB => clkB,
            resetn=>resetn, 
            led_0_r => led_0_r, 
            led_0_g => led_0_g, 
            led_0_b => led_0_b,
            led_1_r => led_1_r, 
            led_1_g => led_1_g, 
            led_1_b => led_1_b,
            end_cycle => end_cycle
            
        );
		
	--Simulation du signal d'horloge en continue
--	process
--    begin
--		wait for hpA;
--		clkA <= not clkA;
--	end process;
	
--	process
--    begin
--		wait for hpB;
--		clkB <= not clkB;
--	end process;

	process
    begin
		wait for hp;
		clk <= not clk;
	end process;


	process
	begin        
	   
	   -- TESTS A EFFECTUER
	   
	   resetn <= '1';
	   wait for 5*period;
	   resetn <= '0';
	   
	   
	   wait for 100*period;
	 
	   
	     
	   wait for 100000*period;
	
	   
	end process;
	
	
end behavioral;

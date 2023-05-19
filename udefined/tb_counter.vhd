library ieee;
use ieee.std_logic_1164.all;



entity tb_counter_fsm is
end tb_counter_fsm;


architecture behavioral of tb_counter_fsm is

	signal resetn          : std_logic := '0';
	signal clk             : std_logic := '0';
	signal bp_0              : std_logic := '0';
	signal bp_1              : std_logic := '0';
	signal led_r           :  std_logic;
    signal led_g           :  std_logic;
    signal led_b           :  std_logic;
    
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	constant u_time : time :=1.25 us;
	
	
	--Declaration de l'entite a tester
	component  led  
		port ( 
			clk			: in std_logic; 
			resetn      : in std_logic;
            bp_0        : in std_logic;
            bp_1        : in std_logic;
            led_r       : out std_logic;
            led_g       : out std_logic;
            led_b       : out std_logic
            
		 );
	end component;
	
	

	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	comp_led: led 
        port map (
            clk => clk,
            resetn=>resetn, 
            bp_0 =>bp_0, 
            bp_1 =>bp_1,
            led_r => led_r,
            led_g => led_g,
            led_b => led_b
            
        );
		
	--Simulation du signal d'horloge en continue
	process
    begin
		wait for hp;
		clk <= not clk;
	end process;


	process
	begin        
	   
	   -- TESTS A EFFECTUER
	   
	   resetn <= '1';
	   wait for period;
	   resetn <= '0';
	   
	   
	   wait for 100*period;
	   bp_0 <= '1';
	   wait for period;
	   bp_0 <= '0';
	   
	   wait for 100*period;
	   bp_1 <= '1';
	   
	   wait for 30*period;
	   bp_0 <= '1';
	   wait for period;
	   bp_0 <= '0';
	   wait for 200*period;
	   bp_1 <= '0';
	   
	     
	   wait for 1000*period;
	
	   
	end process;
	
	
end behavioral;

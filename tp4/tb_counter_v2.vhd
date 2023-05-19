library ieee;
use ieee.std_logic_1164.all;



entity tb_counter_fsm is
end tb_counter_fsm;


architecture behavioral of tb_counter_fsm is

	signal resetn          : std_logic := '0';
	signal clk             : std_logic := '0';
	signal bp              : std_logic := '0';
	signal color_code      : std_logic_vector (1 downto 0);
    signal update          :  std_logic;
	signal led_r           :  std_logic;
    signal led_g           :  std_logic;
    signal led_b           :  std_logic;
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	constant u_time : time :=1.25 us;
	--constant long_time : time := 2000 ms;
	
	--Declaration de l'entite a tester
	component  led  
		port ( 
			clk             : in std_logic;
		    resetn          : in std_logic;
		    color_code      : in std_logic_vector (1 downto 0);
            update          : in std_logic;
		    led_r           : out std_logic;
            led_g           : out std_logic;
            led_b           : out std_logic
		 );
	end component;
	
	

	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	u_tp_fsm: led 
        port map (
            clk => clk, 
            resetn=>resetn, 
            color_code =>color_code,
            update => update,
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
	   color_code  <= "00";
	   resetn <= '1';
	   update<= '0';
	   wait for period;
	   resetn <= '0';
	   
	   color_code  <= "01";
	   --wait for 100*period;
	   update <= '1';
	   wait for period;
	   update <= '0';
	   
	   wait for 100*period;

        color_code  <= "10";
	   update <= '1';
	   wait for period;
	   update <= '0';
	   wait for 100*period;

        color_code  <= "11";
	   update <= '1';
	   wait for period;
	   update <= '0';
	   wait for 100*period;
	   
	   color_code  <= "00";
	   update <= '1';
	   wait for period;
	   update <= '0';
	   wait for 100*period;
	   

	   wait for 1000*period;
	
	   
	end process;
	
	
end behavioral;

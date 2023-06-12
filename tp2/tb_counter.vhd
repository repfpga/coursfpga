library ieee;
use ieee.std_logic_1164.all;

entity tb_counter is
end tb_counter;

architecture behavioral of tb_counter is

	signal rstn      : std_logic := '0';
	signal clk         : std_logic := '0';
	signal restart         : std_logic := '0';
	signal end_counter : std_logic;
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	--constant long_time : time := 2000 ms;
	
	--Declaration de l'entite a tester
	component counter_unit 
		port ( 
			clk			: in std_logic; 
			rstn		: in std_logic;
			restart     : in std_logic;
			end_counter : out std_logic
		 );
	end component;
	
	

	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	uut: counter_unit
        port map (
            clk => clk, 
            rstn=>rstn, 
            restart=>restart,
            end_counter => end_counter
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
	   rstn <= '1';
	   wait for 10ns;
	   rstn <= '0';
	   
	   wait for 1000ns;
--	   wait for long_time;
--	   assert end_counter='1' report "test fail" severity failure;
	
	   
	end process;
	
	
end behavioral;



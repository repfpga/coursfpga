library ieee;
use ieee.std_logic_1164.all;



entity tb_counter_fsm is
end tb_counter_fsm;


architecture behavioral of tb_counter_fsm is

	signal resetn      : std_logic := '0';
	signal clk         : std_logic := '0';
	signal restart         : std_logic := '0';
	signal r           :  std_logic;
    signal v           :  std_logic;
    signal b           :  std_logic;
	
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      --demi periode de 5ns
	constant period : time := 2*hp;  --periode de 10ns, soit une frequence de 100Hz
	constant u_time : time :=1.25 us;
	--constant long_time : time := 2000 ms;
	
	--Declaration de l'entite a tester
	component  tp_fsm  
		port ( 
			clk : in std_logic;
		    resetn : in std_logic;
		    restart : in std_logic;
		    r           : out std_logic;
            v           : out std_logic;
            b           : out std_logic
		 );
	end component;
	
	

	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	u_tp_fsm: tp_fsm 
        port map (
            clk => clk, 
            resetn=>resetn, 
            restart=>restart,
            r => r,
            v => v,
            b => b
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
	   wait for 10ns;
	   resetn <= '0';
	   
	   wait for period;
	   assert r='1' report "test fail" severity failure;
	   assert v='1' report "test fail" severity failure;
	   assert b='1' report "test fail" severity failure;
	   
	   wait for u_time;
	   assert r='1' report "test failr1" severity failure;
	   assert v='0' report "test fail" severity failure;
	   assert b='0' report "test fail" severity failure;
	   
	   wait for u_time;
	   assert r='0' report "test fail" severity failure;
	   assert v='0' report "test fail" severity failure;
	   assert b='1' report "test fail" severity failure;
	   
	   wait for u_time;
	   assert r='0' report "test fail" severity failure;
	   assert v='1' report "test fail" severity failure;
	   assert b='0' report "test fail" severity failure;
	   
	
	   
	   
	   wait for 10000ns;
	
	   
	end process;
	
	
end behavioral;

library ieee;
use ieee.std_logic_1164.all;


entity tb is
end tb;


architecture behavioral of tb is

	signal clk : std_logic :='0';
	signal reset_i : std_logic;
    signal vga_hs_o : STD_LOGIC;
    signal vga_vs_o : STD_LOGIC;
    signal vga_r_o : STD_LOGIC_VECTOR (3 downto 0);
    signal vga_b_o : STD_LOGIC_VECTOR (3 downto 0);
    signal vga_g_o : STD_LOGIC_VECTOR (3 downto 0);
    
          
	-- Les constantes suivantes permette de definir la frequence de l'horloge 
	constant hp : time := 5 ns;      
	constant period : time := 2*hp; 
	
	
	
	--Declaration de l'entite a tester
	component  top  
		port ( 
		   clk_i : in  STD_LOGIC;
		   reset_i :in STD_LOGIC;
           vga_hs_o : out  STD_LOGIC;
           vga_vs_o : out  STD_LOGIC;
           vga_r_o : out  STD_LOGIC_VECTOR (3 downto 0);
           vga_g_o : out  STD_LOGIC_VECTOR (3 downto 0);
           vga_b_o : out  STD_LOGIC_VECTOR (3 downto 0)           
		 );
	end component;
	
	
	begin
	
	--Affectation des signaux du testbench avec ceux de l'entite a tester
	comp_top: top 
        port map (
                clk_i=>clk,
                reset_i=>reset_i,             
                vga_hs_o =>vga_hs_o,
                vga_vs_o =>vga_vs_o,
                vga_r_o=>vga_r_o,
                vga_g_o=>vga_g_o,
                vga_b_o=>vga_b_o
       );
		
	process
    begin
		wait for hp;
		clk <= not clk;
	end process;

    process
    begin
        reset_i <= '1';
        wait for period;
        reset_i <= '0';
         wait ; -- wait to finish all the clock cycle
    end process;     


	process
	begin        
	   
	   -- TESTS A EFFECTUER
	   
  
	end process;
	
	
end behavioral;

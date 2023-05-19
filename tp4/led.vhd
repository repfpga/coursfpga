library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity led is
--    generic (
--        --vous pouvez ajouter des parameres generics ici
--    );
    port ( 
		clk			: in std_logic;
		resetn      : in std_logic;
        bp_0        : in std_logic;
        bp_1        : in std_logic;
        led_r       : out std_logic;
        led_g       : out std_logic;
        led_b       : out std_logic
		--a completer
     );
end led;

architecture behavioral of led is


signal Q : std_logic;
signal Q2 : std_logic;
signal update : std_logic;
signal color_code : std_logic_vector(1 downto 0);
    	 
component module_rgb 
		port ( 
		clk : in std_logic;
		resetn : in std_logic;
		color_code : in std_logic_vector(1 downto 0);
		update : in std_logic;
		led_r : out std_logic;
        led_g : out std_logic;
        led_b : out std_logic
		);
	end component;
	
	
	begin
	
	
	-- realisation d'un registre à decalage    
    process(clk, resetn)
    begin
        if (resetn = '1') then 
            
            Q <= '0';
            Q2 <= '0';
            
        elsif (rising_edge(clk)) then
            
              Q <= bp_0;
              Q2 <= Q;
              
        end if;
    end process; 
    -- combiné avec une porte and    
    update<=(Q and not(Q2)); 
    -- réalisation d'un detecteur de front montant 
	
	
	
	-- realisation d'un multiplexeur 
    -- qui permet le choix entre le signal 
    -- "10" et "11"
    -- en fonction de bp_1
    
    process(bp_1)
    begin
        if(bp_1='1') then
            color_code <="10";
        else
            color_code <="11";
        end if;                                                                                                                                                 
    end process;

   
module_rgb_comp: module_rgb
        port map (
        clk => clk,
		resetn =>resetn,
		color_code =>color_code,
		update=>update,
		led_r =>led_r, 
        led_g =>led_g,
        led_b =>led_b
        );


end behavioral;
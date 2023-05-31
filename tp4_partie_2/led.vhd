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
signal end_cycle : std_logic;

        
signal din : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal wr_en : STD_LOGIC;
signal rd_en : STD_LOGIC;
signal dout : STD_LOGIC_VECTOR(1 DOWNTO 0);
signal full : STD_LOGIC;
signal empty : STD_LOGIC;

signal Q3 : std_logic;
    	 
component module_rgb 
		port ( 
		clk : in std_logic;
		resetn : in std_logic;
		color_code : in std_logic_vector(1 downto 0);
		update : in std_logic;
		led_r : out std_logic;
        led_g : out std_logic;
        led_b : out std_logic;
        end_cycle : out std_logic
		);
	end component;
	
component fifo_generator_0 
		port ( 
		clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
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
    --update <= (Q and not(Q2));
       wr_en <= (Q and not(Q2));
    --wr_en <= update; 
    update<='1';
    
    --wr_en<='1';
    
    -- réalisation d'un detecteur de front montant 
	
	process(clk, resetn)
    begin
        if (resetn = '1') then 
                      
            Q3 <= '0';
            
        elsif (rising_edge(clk)) then
                        
              Q3 <= end_cycle;
              
        end if;
    end process;
	
	rd_en<=Q3;
	
	
	-- realisation d'un multiplexeur 
    -- qui permet le choix entre le signal 
    -- "10" et "11"
    -- en fonction de bp_1
    
    process(bp_1)
    begin
        if(bp_1='1') then
            --color_code <="10";
            din <="10";
        else
            --color_code <="11";
            din <="11";
        end if;                                                                                                                                                 
    end process;


    color_code <= dout;
   
module_rgb_comp: module_rgb
        port map (
        clk => clk,
		resetn =>resetn,
		color_code =>color_code,
		update=>update,
		led_r =>led_r, 
        led_g =>led_g,
        led_b =>led_b,
        end_cycle => end_cycle 
        );

fifo_comp: fifo_generator_0
        port map (
        clk => clk,
        srst => resetn,
        din => din,
        wr_en => wr_en,
        rd_en => rd_en,
        dout => dout,
        full => full,
        empty => empty
        );


end behavioral;
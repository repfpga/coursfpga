library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity fsm is
--    generic (
--        --vous pouvez ajouter des parameres generics ici
--    );
    port ( 
        clk : in std_logic;
--		clkA	: in std_logic; 
--		clkB	: in std_logic;
        resetn	: in std_logic;
        led_0_r : out std_logic;
        led_0_g : out std_logic;
        led_0_b : out std_logic;
        led_1_r : out std_logic;
        led_1_g : out std_logic;
        led_1_b : out std_logic;
        end_cycle : out std_logic
        

     );
end fsm;

architecture behavioral of fsm is

    type state is (rouge, bleu, vert); 
    
    signal current_state : state;  --etat dans lequel on se trouve actuellement
    signal next_state : state;	   --etat dans lequel on passera au prochain coup d'horloge
    
     signal color_code: std_logic_vector(1 downto 0);
     signal update: std_logic;

    signal end_cycle_int: std_logic;
    signal end_cycle_int_2: std_logic;
    
    signal r_Count: integer range 0 to 5 :=0;
    signal update_stretched: std_logic;
--    signal update_metastable : std_logic; 
--    signal update_stable : std_logic;
    
    signal clkA	: std_logic; 
    signal clkB	: std_logic;
    
    signal locked : std_logic;
    
    signal color_code_1: std_logic_vector(1 downto 0);
    signal color_code_dec: std_logic_vector(1 downto 0);
    
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
	
	component clk_wiz_0 
		port (		
		clk_out1 : out std_logic;
		clk_out2 : out std_logic;
		reset : in std_logic;
		locked : out std_logic;
		clk_in1: in std_logic
		);
	end component;
	
	
	begin
rgb_comp_0: module_rgb
        port map (
            clk => clkA,  
            resetn => resetn,
            color_code => color_code,
            update => update,
            led_r => led_0_r, 
            led_g => led_0_g, 
            led_b => led_0_b,
            end_cycle => end_cycle_int
        );
	
rgb_comp_1: module_rgb
        port map (
            clk => clkB, 
            resetn => resetn,
            color_code => color_code_dec,
            update => update_stretched,
            led_r => led_1_r, 
            led_g => led_1_g, 
            led_b => led_1_b,
            end_cycle => end_cycle_int_2
        );

pll_comp: clk_wiz_0
        port map (
            clk_out1 =>clkA,
		    clk_out2 =>clkB,
		    reset=>resetn,
		    locked =>locked,
		    clk_in1 => clk
        );


      
        process(clkA,resetn)
		begin
            if(resetn='1') then
            
                current_state <= rouge;
                 
			elsif(rising_edge(clkA)) then
			
				current_state <= next_state;
				
				
				
            end if;
		end process;
        
        
        
		
		-- FSM
		process(current_state,end_cycle_int) 
		begin		
           case current_state is
             
              when rouge =>
			      color_code<="01";
			      update<='0';
                 
				if (end_cycle_int = '1') then
                        next_state <= bleu; --prochain etat
                        update<='1';
                      
                  else
                        next_state<=rouge;
                        
                  end if;
                
              
              when bleu =>
			      color_code<="11";
			      update<='0';
			                        
				if (end_cycle_int = '1') then
                        next_state <= vert; --prochain etat
                       update<='1';
                  else
                        next_state<=bleu;
                       
                  end if;
                  
               when vert =>
			      color_code<="10";
			      update<='0';
                  
				if (end_cycle_int = '1') then
                        next_state <= rouge; --prochain etat
                        update<='1';
                  else
                        next_state<=vert;
                        
                  end if;
              
              end case;
              
          
		end process;
	
	--étirement du signal update	
	process (clkA,resetn) is
	begin
        if (resetn = '1') then 
            r_Count <= 0;
        elsif (rising_edge(clkA))then
               if(update='1')then
                     r_Count <= 5;
               elsif ( r_Count > 0 )then
                     r_Count<= r_Count -1;
               end if;
        end if;
	end process;
	
	update_stretched <='1'	when r_Count>0 else '0';
	
	


--double decalage du signal color_code
process (clkA,resetn) is
	begin
	    if (resetn = '1') then 
            color_code_1 <= "00";
            color_code_dec <= "00";
        elsif (rising_edge(clkA))then
            color_code_1 <= color_code;
            color_code_dec <= color_code_1;
            
        end if;
	end process;
		
	
	
		
	end_cycle<=end_cycle_int;	

end behavioral;
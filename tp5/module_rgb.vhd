library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity module_rgb is
	generic (
	cte : positive := 20
	
	);
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
end module_rgb;

architecture behavioral of module_rgb is

type state is (idle_led_off, led_on); 
    
    signal current_state : state;  --etat dans lequel on se trouve actuellement
    signal next_state : state;	   --etat dans lequel on passera au prochain coup d'horloge
    signal end_counter : std_logic;
    signal led_int: std_logic;
    signal Q : std_logic_vector(1 downto 0);
    signal nc: std_logic;
    
    
    
    signal Q2 : std_logic_vector(4 downto 0); 
   	signal end_counter_int_al : std_logic;
   	
    
    
     
component counter_unit 
		port ( 
		clk : in std_logic;
		rstn : in std_logic;
		end_counter : out std_logic
		);
	end component;
	
	
	begin
counter_comp: counter_unit
        port map (
            clk => clk, 
            rstn=>resetn, 
            end_counter => end_counter
        );
	
	--gestion update
    process(clk, resetn)
    begin
        if (resetn = '1') then 
            
           Q <= (others => '0');
            
            
        elsif (rising_edge(clk)) then
            
              if(update='1')then
                    Q <= color_code;
              else
                    Q <= Q;
              end if;
              
              
        end if;
    end process;   
    
    -- realisation d'un demultiplexeur 
    -- qui permet de recuperer le signal 
    -- led_int soit sur la broche led correspondante
        
    process(Q,led_int)
    begin
        if(Q="00") then
            led_r<='0';
            led_g<='0';
            led_b<='0';
            nc<=led_int;
        elsif(Q="01")then
            led_r<=led_int;
            led_g<='0';
            led_b<='0';
            nc<='0';
        elsif(Q="10")then
            led_r<='0';
            led_g<=led_int;
            led_b<='0';
            nc<='0';
        else
            led_r<='0';
            led_g<='0';
            led_b<=led_int;
            nc<='0';   
         end if;                                                                                                                                                 
    end process;
      
        
        

        --gestion etat suivant
        process(clk,resetn)
		begin
            if(resetn='1') then
            
                current_state <= idle_led_off;
                 
			elsif(rising_edge(clk)) then
			
				current_state <= next_state;
				
							
            end if;
		end process;
        
        
        
		--gestion des transitions
		-- FSM
		process(current_state,end_counter) --a completer avec vos signaux
		begin		
           case current_state is
              when idle_led_off  =>
                  led_int <= '0';
                    
                  if (end_counter = '1') then
                        next_state <= led_on; --prochain etat
                      
                  else
                        next_state<=idle_led_off;
                       
                  end if;
				
				
                          
              when led_on =>
			      led_int <= '1';
                    
				if (end_counter = '1') then
                        next_state <= idle_led_off; --prochain etat
                      
                  else
                        next_state<=led_on;
                        
                  end if;
              
              
              
              
              end case;
              
          
		end process;
		
--comptage nombre de cycles allumés éteints			
process(clk, resetn)
begin
	if (resetn = '1') then 
		Q2 <= (others => '0');
		
		
	elsif (rising_edge(clk)) then

		if (end_counter_int_al='1') then 
			Q2 <= (others => '0');
			
		else
			if (end_counter ='1') then
			     Q2 <= Q2 + 1;
			else
			     Q2 <= Q2;
			end if;
		end if;
		
		
	
	end if;
end process; 

	end_counter_int_al <= '1' when (Q2 =  cte - 1) and (end_counter ='1')
				else '0';
				
	end_cycle <= end_counter_int_al;
    
    
	

end behavioral; 
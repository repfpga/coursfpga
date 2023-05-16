library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity tp_fsm is
--    generic (
--        --vous pouvez ajouter des parameres generics ici
--    );
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        restart		: in std_logic;
        r           : out std_logic;
        v           : out std_logic;
        b           : out std_logic
		--a completer
     );
end tp_fsm;

architecture behavioral of tp_fsm is

    type state is (idle_blanc, rouge, bleu, vert); --a modifier avec vos etats
    
    signal current_state : state;  --etat dans lequel on se trouve actuellement
    signal next_state : state;	   --etat dans lequel on passera au prochain coup d'horloge
    
    
    
     signal end_counter_al : std_logic;
     signal end_counter_2 : std_logic;
     
     signal r_int: std_logic;
     signal v_int: std_logic;
     signal b_int: std_logic;
           
     signal Q: std_logic;
     signal led_on:std_logic;
    
     
component counter_al 
		port ( 
		clk : in std_logic;
		rstn : in std_logic;
		restart : in std_logic;
		end_counter_al : out std_logic;
		end_counter_2 : out std_logic
		);
	end component;
	
	
	begin
counter_al_comp: counter_al
        port map (
            clk => clk, 
            rstn=>resetn, 
            restart => restart,
		    end_counter_al => end_counter_al,
		    end_counter_2 => end_counter_2
        );
	



process(clk, resetn)
begin
	if (resetn = '1') then 
		
		Q <= '1';
	
	elsif (rising_edge(clk)) then
		
		  if(end_counter_2='1') then 
            Q <= not Q;
    	  else
		    Q <= Q;
		  end if;
	end if;
end process; 

        led_on<=Q;
    
		r <= r_int when led_on='1'
		else '0';
		
		v <= v_int when led_on='1'
		else '0';
		
		b <= b_int when led_on='1'
		else '0';
		
        --v <= not (v_int) when end_counter_2 = '1';

        

        
        process(clk,resetn)
		begin
            if(resetn='1') then
            
                current_state <= idle_blanc;
                 
			elsif(rising_edge(clk)) then
			
				current_state <= next_state;
				
				--a completer avec votre compteur de cycles
				
				
            end if;
		end process;
        
        
        
		
		-- FSM
		process(current_state,end_counter_al) --a completer avec vos signaux
		begin		
           case current_state is
              when idle_blanc  =>
                  r_int <= '1';
                  v_int <= '1';
                  b_int <= '1';
                  
                  if (end_counter_al = '1') then
                        next_state <= rouge; --prochain etat
                      
                  else
                        next_state<=idle_blanc;
                       
                  end if;
				
				
                --signaux pilotes par la fsm
              
              when rouge =>
			      r_int <= '1';
                  v_int <= '0';
                  b_int <= '0';
                 
				if (end_counter_al = '1') then
                        next_state <= bleu; --prochain etat
                      
                  else
                        next_state<=rouge;
                        
                  end if;
                --signaux pilotes par la fsm
              
              when bleu =>
			      r_int <= '0';
                  v_int <= '0';
                  b_int <= '1';
                  
				if (end_counter_al = '1') then
                        next_state <= vert; --prochain etat
                       
                  else
                        next_state<=bleu;
                       
                  end if;
                  
               when vert =>
			      r_int <= '0';
                  v_int <= '1';
                  b_int <= '0';
                  
				if (end_counter_al = '1') then
                        next_state <= rouge; --prochain etat
                        
                  else
                        next_state<=vert;
                        
                  end if;
              
              end case;
              
          
		end process;
		
		
		

end behavioral;
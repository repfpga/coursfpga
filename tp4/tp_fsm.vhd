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
        bp		    : in std_logic;
        r           : out std_logic;
        v           : out std_logic;
        b           : out std_logic
		--a completer
     );
end tp_fsm;

architecture behavioral of tp_fsm is

    type state is (idle_led_off, led_on); --a modifier avec vos etats
    
    signal current_state : state;  --etat dans lequel on se trouve actuellement
    signal next_state : state;	   --etat dans lequel on passera au prochain coup d'horloge
    
    signal end_counter : std_logic;
    signal led_int: std_logic;
    
    signal Q : std_logic;
    signal Q2 : std_logic;
    signal r_edge_bp  : std_logic;
    
    signal led_int_2: std_logic;
    
     
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
	
    -- realisation d'un registre a decalage    
    process(clk, resetn)
    begin
        if (resetn = '1') then 
            
            Q <= '0';
            Q2 <= '0';
            
        elsif (rising_edge(clk)) then
            
              Q <= bp;
              Q2 <= Q;
              
        end if;
    end process; 
    -- combiné avec une porte and    
    r_edge_bp<=(Q and not(Q2)); 
    -- réalisation d'un detecteur de front montant  
    
    -- realisation d'un multiplexeur 
    -- qui permet le chaoix entre le signal 
    -- r_edge_bp et led_int
    -- en fonction de r_edge_bp 
    process(r_edge_bp,led_int)
    begin
        if(r_edge_bp='1') then
            led_int_2 <=r_edge_bp;
        else
            led_int_2 <=led_int;
        end if;                                                                                                                                                 
    end process;
    
    
    -- realisation d'un demultiplexeur 
    -- qui permet de recuperer le signal 
    -- led_int_2 soit sur la broche verte
    --soit sur la broche rouge
        
    process(r_edge_bp,led_int_2)
    begin
        if(r_edge_bp='1') then
            v <=led_int_2;
            r <='0';
        else
            v<='0';
            r <=led_int_2;
        end if;                                                                                                                                                 
    end process;
      
      b<='0';      
        

        --gestion etat suivant
        process(clk,resetn)
		begin
            if(resetn='1') then
            
                current_state <= idle_led_off;
                 
			elsif(rising_edge(clk)) then
			
				current_state <= next_state;
				
				--a completer avec votre compteur de cycles
				
				
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
				
				
                --signaux pilotes par la fsm
              
              when led_on =>
			      led_int <= '1';
                    
				if (end_counter = '1') then
                        next_state <= idle_led_off; --prochain etat
                      
                  else
                        next_state<=led_on;
                        
                  end if;
                --signaux pilotes par la fsm
              
              
              
              end case;
              
          
		end process;
		
		
		

end behavioral;
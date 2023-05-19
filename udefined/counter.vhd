library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity counter_al is
    generic (
	cte : positive := 6 
	);
    port ( 
		clk : in std_logic;
		rstn : in std_logic;
		restart : in std_logic;
		end_counter_al : out std_logic;
		end_counter_2 : out std_logic
     );
end counter_al;

architecture behavioral of counter_al is
	
	--Declaration des signaux internes
   	signal Q : std_logic_vector(2 downto 0); 
   	signal end_counter : std_logic; 
   	signal end_counter_int_al : std_logic;
	
	component counter_unit 
		port ( 
			clk			: in std_logic; 
			rstn		: in std_logic;
			end_counter : out std_logic
		 );
	end component;
	
	
begin

counter_unit_comp: counter_unit
        port map (
            clk => clk, 
            rstn=>rstn, 
            end_counter => end_counter
        );

process(clk, rstn)
begin
	if (rstn = '1') then 
		Q <= (others => '0');
		
		
	elsif (rising_edge(clk)) then

		if (restart='1' or end_counter_int_al='1') then 
			Q <= (others => '0');
			
		else
			if (end_counter ='1') then
			     Q <= Q + 1;
			else
			     Q <= Q;
			end if;
		end if;
		
		
	
	end if;
end process; 

	end_counter_int_al <= '1' when (Q =  cte - 1) and (end_counter ='1')
				else '0';
				
	end_counter_al <= end_counter_int_al;
    
    end_counter_2 <= end_counter;
end behavioral; 
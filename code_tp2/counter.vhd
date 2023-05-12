library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity counter_unit is
    port ( 
		clk : in std_logic;
		rstn : in std_logic;
		restart : in std_logic;
		end_counter : out std_logic
     );
end counter_unit;

architecture behavioral of counter_unit is
	
	--Declaration des signaux internes
    constant cte : positive := 200000000;
    --constant cte : positive := 20;
    
	signal Q : std_logic_vector(27 downto 0); 
	signal end_counter_int : std_logic; 
	signal Q2 : std_logic;
	
	
	
begin
process(clk, rstn)
begin
	if (rstn = '1') then 
		Q <= (others => '0');
		Q2 <= '0';
		
	elsif (rising_edge(clk)) then

		if (end_counter_int='1' or restart='1') then 
			Q <= (others => '0');
			
		else
			Q <= Q + 1;
		end if;
		
		if(end_counter_int='1') then 
            Q2 <= not Q2;		
		else
		    Q2 <= Q2;
		end if;
	
	end if;
end process; 


	end_counter_int <= '1' when Q =  cte - 1
				else '0';
				

	end_counter <= Q2;
	

end behavioral; 
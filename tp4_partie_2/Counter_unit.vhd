library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity counter_unit is
	generic (
	--cte : positive := 20
	cte : positive := 200000000 
	);
    port ( 
		clk : in std_logic;
		rstn : in std_logic;
		end_counter : out std_logic
     );
end counter_unit;

architecture behavioral of counter_unit is
	
	--Declaration des signaux internes
  
    
    
	signal Q : std_logic_vector(27 downto 0); 
	signal end_counter_int : std_logic; 

	
	
begin
process(clk, rstn)
begin
	if (rstn = '1') then 
		Q <= (others => '0');
		
	elsif (rising_edge(clk)) then

		if (end_counter_int='1') then 
			Q <= (others => '0');
			
		else
			
		      Q <= Q + 1;
		end if;
	
	end if;
end process; 



	
	end_counter_int <= '1' when Q =  cte - 1
				else '0';
				
	end_counter <= end_counter_int;

end behavioral; 
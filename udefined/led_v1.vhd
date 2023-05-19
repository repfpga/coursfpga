library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity led is
--    generic (
--        --vous pouvez ajouter des parameres generics ici
--    );
    port ( 
		clk			: in std_logic; 
        resetn		: in std_logic;
        color_code  : in std_logic_vector (1 downto 0);
        update      : in std_logic;
        led_r       : out std_logic;
        led_g       : out std_logic;
        led_b       : out std_logic
		--a completer
     );
end led;

architecture behavioral of led is

    	 
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
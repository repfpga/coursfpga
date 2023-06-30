library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity filtre_gaussien is
    Port ( clk_25_i : in  STD_LOGIC;
           clk_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
       --    h_cntr_reg_i : in  std_logic_vector(11 downto 0);
        --   v_cntr_reg_i : in  std_logic_vector(11 downto 0);
           data_red_i : in  STD_LOGIC_VECTOR (3 downto 0);
           data_blue_i : in  STD_LOGIC_VECTOR (3 downto 0);
           data_green_i : in  STD_LOGIC_VECTOR (3 downto 0);
         --  h_cntr_reg_o : out  std_logic_vector(11 downto 0);
         --  v_cntr_reg_o : out  std_logic_vector(11 downto 0);
           data_red_o : out  STD_LOGIC_VECTOR (3 downto 0);
           data_green_o : out  STD_LOGIC_VECTOR (3 downto 0);
           data_blue_o : out  STD_LOGIC_VECTOR (3 downto 0);
           enable_o    : out std_logic);
end filtre_gaussien;

architecture Behavioral of filtre_gaussien is

component system_conv
		port(
			filter_sel: in std_logic_vector(1 downto 0);
			reset, global_clock, clk_25_i: in std_logic;
			data_read: in std_logic_vector(7 downto 0);
			image_width: in std_logic_vector(12 downto 0);
			image_height: in std_logic_vector(12 downto 0);
			data_write: out std_logic_vector(7 downto 0);
			enable: out std_logic;
			data_ready: out std_logic;

			--Test signals
			clk_test_div: out std_logic;
			pixel_1, pixel_2, pixel_3, pixel_4, pixel_5,
			pixel_6, pixel_7, pixel_8, pixel_9: out std_logic_vector(7 downto 0));
	end component;

    signal clk: std_ulogic;
	signal reset: std_logic;
	signal filter_sel: std_logic_vector(1 downto 0);
	signal image_width, image_height: std_logic_vector(12 downto 0);
	signal data_write: std_logic_vector(7 downto 0);
	signal enable, data_ready: std_logic;
	signal data_read: std_logic_vector(7 downto 0);
    signal s_enable: std_logic:='0';
	--test signals
	signal clk_test_div: std_logic;
	signal pixel_1, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_8, pixel_9: std_logic_vector(7 downto 0);

 signal data_red_reg: STD_LOGIC_VECTOR (3 downto 0);
signal data_green_reg: STD_LOGIC_VECTOR (3 downto 0);
signal data_blue_reg: STD_LOGIC_VECTOR (3 downto 0);

           

begin
  unit: system_conv
			port map(global_clock => clk, clk_25_i => clk_25_i,reset => reset, filter_sel => filter_sel, image_width => image_width, image_height => image_height,
				data_read => data_read, data_write => data_write, enable => enable, data_ready => data_ready, clk_test_div => clk_test_div,
				pixel_1 => pixel_1, pixel_2 => pixel_2, pixel_3 => pixel_3, pixel_4 => pixel_4, pixel_5 => pixel_5,
				pixel_6 => pixel_6, pixel_7 => pixel_7, pixel_8 => pixel_8, pixel_9 => pixel_9);
  
  
  clk<=clk_i;
  reset<=reset_i;
  enable_o <= s_enable;
  process(data_ready, enable,data_write)
		
		begin
		if(enable = '1' and rising_edge(data_ready)) then
		data_red_reg<= data_write(7 downto 4);
		data_green_reg<= data_write(7 downto 4);
		data_blue_reg<= data_write(7 downto 4);
		
		end if;
	end process;
	-------------------
	----------------------
	
  process (enable)
  begin
  if rising_edge(enable) then
  s_enable <='1';
  end if;
  end process;
  -------------------------------
    image_width <= "0001000000000";
	image_height <= "0000110011010";
    filter_sel <= "00";
	
	
	
	data_read <= "11111111" when data_red_i = "1111"
    else "00000000" when data_red_i = "0000";
	
	
  
--  h_cntr_reg_o<=h_cntr_reg_i;
--  v_cntr_reg_o<=v_cntr_reg_i;
    
  data_red_o <= data_red_reg;
  data_green_o <= data_green_reg;
  data_blue_o <= data_blue_reg;

  
end Behavioral;

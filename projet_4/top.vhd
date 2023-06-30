library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity top is
    Port ( clk_i : in  STD_LOGIC;
           reset_i : in STD_LOGIC;
           vga_hs_o : out  STD_LOGIC;
           vga_vs_o : out  STD_LOGIC;
           vga_r_o : out  STD_LOGIC_VECTOR (3 downto 0);
           vga_g_o : out  STD_LOGIC_VECTOR (3 downto 0);
           vga_b_o : out  STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

component clk_wiz_0
port
 (-- Clock in ports
  RESET             : in     std_logic;
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  LOCKED            : out   std_logic
 );
end component;

component generateur_pattern
port
 (
    clk_25_i : in  STD_LOGIC;
    reset_i : in  STD_LOGIC;
    data_red_o : out  STD_LOGIC_VECTOR (3 downto 0);
    data_blue_o : out  STD_LOGIC_VECTOR (3 downto 0);
    data_green_o : out  STD_LOGIC_VECTOR (3 downto 0)
 );
end component;

component system_conv
port(
		filter_sel: in std_logic_vector(1 downto 0);
		reset, global_clock, clk_25_i: in std_logic;
		data_read: in std_logic_vector(7 downto 0);
		image_width: in std_logic_vector(12 downto 0);
		image_height: in std_logic_vector(12 downto 0);
		data_write: out std_logic_vector(7 downto 0);
		enable: out std_logic;
		data_ready: out std_logic);
end component;

component controleur_vga
port
 (
   clk_25_i : in  STD_LOGIC;
   reset_i : in  STD_LOGIC;
   enable_i : in  STD_LOGIC;
   data_red_i : in  STD_LOGIC_VECTOR (3 downto 0);
   data_blue_i : in  STD_LOGIC_VECTOR (3 downto 0);
   data_green_i : in  STD_LOGIC_VECTOR (3 downto 0);
   vga_hs_o : out  STD_LOGIC;
   vga_vs_o : out  STD_LOGIC;
   vga_r_o : out  STD_LOGIC_VECTOR (3 downto 0);
   vga_g_o : out  STD_LOGIC_VECTOR (3 downto 0);
   vga_b_o : out  STD_LOGIC_VECTOR (3 downto 0)
 );
end component;


signal    clk_25 : std_logic;
--signal    reset: std_logic;
--signal    h_cntr_reg : std_logic_vector(11 downto 0);
--signal    v_cntr_reg : std_logic_vector(11 downto 0);
signal    data_red : std_logic_vector(3 downto 0);
signal    data_blue: std_logic_vector(3 downto 0);
signal    data_green: std_logic_vector(3 downto 0);
signal    locked     : std_logic;
--signal h_cntr_reg_f : std_logic_vector(11 downto 0);
--signal v_cntr_reg_f : std_logic_vector(11 downto 0);
signal data_red_f :std_logic_vector(3 downto 0);
signal data_blue_f :std_logic_vector(3 downto 0);
signal data_green_f :std_logic_vector(3 downto 0);
signal enable :std_logic;
signal data_ready: std_logic;
signal s_enable: std_logic :='0';
signal s_data_red: std_logic_vector(7 downto 0);
signal s_data_write: std_logic_vector (7 downto 0);
begin
  
   
clk_div_inst : clk_wiz_0
  port map
   (-- Clock in ports
    RESET  => reset_i,
    CLK_IN1 => clk_i,
    -- Clock out ports
    LOCKED => locked,
    CLK_OUT1 => clk_25);

generateur_pattern_inst : generateur_pattern
  port map
   (
    clk_25_i => clk_25,
    reset_i =>reset_i,
    data_red_o=>data_red,
    data_blue_o=>data_blue,
    data_green_o=>data_green
);

s_data_red <= "11111111" when data_red = "1111"
    else "00000000" when data_red = "0000";
    


--s_data_red <= "0000"&data_red;

system_conv_inst: system_conv
   port map 
    (
        filter_sel => "11",
		reset => reset_i,
		clk_25_i => clk_25,
		global_clock => clk_i,
		data_read => s_data_red,
		image_width => "0001010000000",
		image_height => "0000111100000",
		data_write => s_data_write,
		enable => enable,
		data_ready => data_ready
);

process (enable)
  begin
  if rising_edge(enable) then
  s_enable <='1';
  end if;
  end process;
  
   process(data_ready, s_enable,s_data_write)
		
		begin
		if(s_enable = '1' and rising_edge(data_ready)) then
		data_red_f<= s_data_write(7 downto 4);
		data_green_f<= s_data_write(7 downto 4);
		data_blue_f<= s_data_write(7 downto 4);
		end if;
	end process;
  
   
	
  
  

--process (reset_i, data_ready)
--begin
--if reset_i ='1' then
--data_red_f <= (others => '0'); 
--data_blue_f <= (others => '0');
--data_green_f <= (others => '0');
--elsif rising_edge(data_ready) then
--if s_enable ='1' then
--data_red_f<= std_logic_vector(resize(unsigned(s_data_write), 4));
--data_blue_f<= std_logic_vector(resize(unsigned(s_data_write), 4));
--data_green_f<= std_logic_vector(resize(unsigned(s_data_write), 4));
-- else
--data_red_f<=data_red_f;
--data_blue_f<=data_blue_f;
--data_green_f<=data_green_f;
--end if;
--end if;
--end process;

controleur_vga_inst : controleur_vga
  port map
   (
    clk_25_i => clk_25,
    enable_i => s_enable,
    reset_i =>reset_i,
    data_red_i=>data_red_f,
    data_blue_i=>data_blue_f,
    data_green_i=>data_green_f,
    vga_hs_o =>vga_hs_o,
    vga_vs_o =>vga_vs_o, 
    vga_r_o =>vga_r_o,
    vga_g_o =>vga_g_o,
    vga_b_o =>vga_b_o    
);

end Behavioral;

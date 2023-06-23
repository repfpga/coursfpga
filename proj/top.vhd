library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;


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
    h_cntr_reg_o : out  std_logic_vector(11 downto 0);
    v_cntr_reg_o : out  std_logic_vector(11 downto 0);
    data_red_o : out  STD_LOGIC_VECTOR (3 downto 0);
    data_blue_o : out  STD_LOGIC_VECTOR (3 downto 0);
    data_green_o : out  STD_LOGIC_VECTOR (3 downto 0)
 );
end component;

component controleur_vga
port
 (
   clk_25_i : in  STD_LOGIC;
   reset_i : in  STD_LOGIC;
   h_cntr_reg_i: in  std_logic_vector(11 downto 0);
   v_cntr_reg_i: in  std_logic_vector(11 downto 0);
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
signal    h_cntr_reg : std_logic_vector(11 downto 0);
signal    v_cntr_reg : std_logic_vector(11 downto 0);
signal    data_red : std_logic_vector(3 downto 0);
signal    data_blue: std_logic_vector(3 downto 0);
signal    data_green: std_logic_vector(3 downto 0);
signal    locked     : std_logic;

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
    h_cntr_reg_o=>h_cntr_reg,
    v_cntr_reg_o=>v_cntr_reg,
    data_red_o=>data_red,
    data_blue_o=>data_blue,
    data_green_o=>data_green
);

controleur_vga_inst : controleur_vga
  port map
   (
    clk_25_i => clk_25,
    reset_i =>reset_i,
    h_cntr_reg_i=>h_cntr_reg,
    v_cntr_reg_i=>v_cntr_reg,
    data_red_i=>data_red,
    data_blue_i=>data_blue,
    data_green_i=>data_green,
    vga_hs_o =>vga_hs_o,
    vga_vs_o =>vga_vs_o, 
    vga_r_o =>vga_r_o,
    vga_g_o =>vga_g_o,
    vga_b_o =>vga_b_o    
);

end Behavioral;

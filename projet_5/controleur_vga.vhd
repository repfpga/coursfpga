library IEEE;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity controleur_vga is
    Port ( clk_25_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
         --  h_cntr_reg_i: in  std_logic_vector (11 downto 0);
		 --  v_cntr_reg_i: in  std_logic_vector (11 downto 0);
		   enable_i    :   in std_logic;
           data_red_i : in  STD_LOGIC_VECTOR (3 downto 0);
           data_green_i : in  STD_LOGIC_VECTOR (3 downto 0);
           data_blue_i : in  STD_LOGIC_VECTOR (3 downto 0);
           vga_hs_o : out  STD_LOGIC;
           vga_vs_o : out  STD_LOGIC;
           vga_r_o : out  STD_LOGIC_VECTOR (3 downto 0);
           vga_g_o : out  STD_LOGIC_VECTOR (3 downto 0);
           vga_b_o : out  STD_LOGIC_VECTOR (3 downto 0));
end controleur_vga;

architecture Behavioral of controleur_vga is

--Sync Generation constants

----***640x480@60Hz***--  Requires 25 MHz clock
constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

constant H_FP : natural := 16; --H front porch width (pixels)
constant H_PW : natural := 96; --H sync pulse width (pixels)
constant H_MAX : natural := 800; --H total period (pixels)

constant V_FP : natural := 10; --V front porch width (lines)
constant V_PW : natural := 2; --V sync pulse width (lines)
constant V_MAX : natural := 525; --V total period (lines)


constant H_POL : std_logic := '0';
constant V_POL : std_logic := '0';

signal h_sync_reg : std_logic := not(H_POL);
signal v_sync_reg : std_logic := not(V_POL);

signal h_sync_dly_reg : std_logic := not(H_POL);
signal v_sync_dly_reg : std_logic :=  not(V_POL);
signal test, test2           : natural :=0;
signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
 
begin 

  
 
 
 
 
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
   if (enable_i='1') then
      if (h_cntr_reg = (H_MAX - 1)) then
        h_cntr_reg <= (others =>'0');
      else
        h_cntr_reg <= h_cntr_reg + 1;
      end if;
      else
       h_cntr_reg <= (others =>'0');
    end if;
    end if;
  end process;
  
  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
    --   if (enable_i='1') then
      if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
        v_cntr_reg <= (others =>'0');
      elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
    --    end if;
    --    else
    --    v_cntr_reg <= (others =>'0');
    
     end if;
    end if;
  end process;
  
 
 ----------------------------------
 ---------------------------------
 
 
  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
      if (unsigned(h_cntr_reg) >= (H_FP + FRAME_WIDTH - 1)) and (unsigned(h_cntr_reg) < (H_FP + FRAME_WIDTH + H_PW - 1)) then
        (h_sync_reg) <= H_POL;
      else
        h_sync_reg <= not(H_POL);
      end if;
    end if;
  end process;
  
  
  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
      if (unsigned(v_cntr_reg) >= (V_FP + FRAME_HEIGHT-1 )) and (unsigned(v_cntr_reg) < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
        v_sync_reg <= V_POL;
      else
        v_sync_reg <= not(V_POL);
      end if;
    end if;
  end process;
  
-- process (clk_25_i)
-- begin
--    if (rising_edge(clk_25_i)) then
--          v_sync_dly_reg <= v_sync_reg;
----      h_sync_dly_reg <= h_sync_reg;
      
--    end if;
--      end process;

 --vga_hs_o <= h_sync_dly_reg;
 --vga_vs_o <= v_sync_dly_reg;
 vga_hs_o <= h_sync_reg;
  vga_vs_o <= v_sync_reg;
  vga_r_o <= data_red_i;
  vga_g_o <= data_green_i;
  vga_b_o <= data_blue_i;
test <= V_FP + FRAME_HEIGHT - 1;
test2 <=H_FP + FRAME_WIDTH - 1;
end Behavioral;

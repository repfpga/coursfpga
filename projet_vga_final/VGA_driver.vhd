----------------------------------------------------------------------------------
-- Company: Digilent
-- Engineer: Arthur Brown
-- 
--
-- Create Date:    13:01:51 02/15/2013 
-- Project Name:   pmodvga
-- Target Devices: arty
-- Tool versions:  2016.4
-- Additional Comments: 
--
-- Copyright Digilent 2017
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_driver is
    Port ( CLK : in  STD_LOGIC;
           RESET_I: in STD_LOGIC;
           DATA_I   : in STD_LOGIC_VECTOR (3 DOWNTO 0);
           gaussian_valid_i: in std_logic;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (3 downto 0));
end VGA_driver;

architecture Behavioral of VGA_driver is


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


--signal pxl_clk : std_logic;
signal active : std_logic;

signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');

signal h_sync_reg : std_logic := not(H_POL);
signal v_sync_reg : std_logic := not(V_POL);

signal h_sync_dly_reg : std_logic := not(H_POL);
signal v_sync_dly_reg : std_logic :=  not(V_POL);

signal vga_red_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal vga_green_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal vga_blue_reg : std_logic_vector(3 downto 0) := (others =>'0');

signal vga_red : std_logic_vector(3 downto 0);
signal vga_green : std_logic_vector(3 downto 0);
signal vga_blue : std_logic_vector(3 downto 0);
 signal s_data_i :  std_logic_vector(3 downto 0);


--signal locked       : std_logic;
--signal reset_auto   : std_logic;
begin
  
   s_data_i <= (data_i);

  ----------------------------------------------------
  -------         TEST PATTERN LOGIC           -------
  ----------------------------------------------------
 
  
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
 
  process (clk)
  begin
    if (rising_edge(clk)) then
    if gaussian_valid_i='1' then
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
  
  process (clk)
  begin
    if (rising_edge(clk)) then
   -- if gaussian_valid_i ='1' then
      if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
        v_cntr_reg <= (others =>'0');
      elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
      end if;
    --  else 
      --v_cntr_reg <= (others =>'0');
     -- end if;
    end if;
  end process;
  
  process (clk)
  begin
    if (rising_edge(clk)) then
      if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then
        h_sync_reg <= H_POL;
      else
        h_sync_reg <= not(H_POL);
      end if;
    end if;
  end process;
  
  
  process (clk)
  begin
    if (rising_edge(clk)) then
      if (v_cntr_reg >= (V_FP + FRAME_HEIGHT -1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW -1)) then
        v_sync_reg <= V_POL;
      else
        v_sync_reg <= not(V_POL);
      end if;
    end if;
  end process;
  
  
  active <= '1' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else
            '0';

  process (clk)
  begin
    if (rising_edge(clk)) then
      v_sync_dly_reg <= v_sync_reg;
      h_sync_dly_reg <= h_sync_reg;
--      vga_red_reg <= vga_red;
--      vga_green_reg <= vga_green;
--      vga_blue_reg <= vga_blue;

    end if;
  end process;

process (clk)
begin
 if (rising_edge(clk)) then
 if (active ='1' and gaussian_valid_i ='1') then
         VGA_R <= (s_data_i);
         VGA_G <= (s_data_i);
         VGA_B <= (s_data_i);
 else
        VGA_R <= (others =>'0');
         VGA_G <= (others =>'0');
         VGA_B <= (others =>'0');
 
 end if;
 end if;
 end process;
   VGA_HS_O <= h_sync_reg;
   VGA_VS_O <= v_sync_reg;
--  VGA_HS_O <= h_sync_dly_reg;
--  VGA_VS_O <= v_sync_dly_reg;
--  VGA_R <= (s_data_i);
--  VGA_G <= (s_data_i);
--  VGA_B <= (s_data_i);

end Behavioral;

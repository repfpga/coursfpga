library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity generateur_pattern is
    Port ( clk_25_i : in  STD_LOGIC;
           reset_i : in  STD_LOGIC;
           h_cntr_reg_o : out  std_logic_vector(11 downto 0);
           v_cntr_reg_o : out  std_logic_vector(11 downto 0);
           data_red_o : out  STD_LOGIC_VECTOR (3 downto 0);
           data_green_o : out  STD_LOGIC_VECTOR (3 downto 0);
           data_blue_o : out  STD_LOGIC_VECTOR (3 downto 0));
end generateur_pattern;

architecture Behavioral of generateur_pattern is


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

signal active : std_logic;

signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');

signal data_red_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal data_green_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal data_blue_reg : std_logic_vector(3 downto 0) := (others =>'0');

signal data_red : std_logic_vector(3 downto 0);
signal data_green : std_logic_vector(3 downto 0);
signal data_blue : std_logic_vector(3 downto 0);

begin
  
  ----------------------------------------------------
  -------         TEST PATTERN LOGIC           -------
  ----------------------------------------------------
  data_red <=  (others=>'1')         when (active = '1' and ((h_cntr_reg <=127) or (h_cntr_reg <= 383 and h_cntr_reg >=256) or (h_cntr_reg >=512 and h_cntr_reg <=639))
                                                       and ((v_cntr_reg <=95) or (v_cntr_reg >=192 and v_cntr_reg <=287) or (v_cntr_reg >=384 and v_cntr_reg <=479)))
                                       
                                          else
              (others=>'1')        when (active = '1' and ((h_cntr_reg >= 128 and h_cntr_reg <=255) or (h_cntr_reg >=384 and h_cntr_reg <=511))
                                                       and ((v_cntr_reg >=96 and v_cntr_reg <=191) or (v_cntr_reg >=288 and v_cntr_reg <=383)))               
                                          else
              (others=>'0');
 
   data_green<=data_red;
   data_blue<=data_red;         
  
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
 
  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
      if (h_cntr_reg = (H_MAX - 1)) then
        h_cntr_reg <= (others =>'0');
      else
        h_cntr_reg <= h_cntr_reg + 1;
      end if;
    end if;
  end process;
  
  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
      if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
        v_cntr_reg <= (others =>'0');
      elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
      end if;
    end if;
  end process;
  
   
  active <= '1' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else
            '0';

  process (clk_25_i)
  begin
    if (rising_edge(clk_25_i)) then
      
      data_red_reg <= data_red;
      data_green_reg <= data_green;
      data_blue_reg <= data_blue;
    end if;
  end process;

 
  data_red_o <= data_red_reg;
  data_green_o <= data_green_reg;
  data_blue_o <= data_blue_reg;

  h_cntr_reg_o<=h_cntr_reg;
  v_cntr_reg_o<=v_cntr_reg;

end Behavioral;

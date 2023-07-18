library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity generateur_pattern is

port (clk : in std_logic;
      active_o: out std_logic;
      data : out std_logic_vector(3 downto 0)
	  );
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


signal locked       : std_logic;
signal reset_auto   : std_logic;
begin
  
    ----------------------------------------------------
  -------         TEST PATTERN LOGIC           -------
  ----------------------------------------------------
-- vga_red <=  (1=> '1', others=>'0')         when (active = '1' and h_cntr_reg =1 and v_cntr_reg =3) else
--             (2=> '1', others=>'0')         when (active = '1' and h_cntr_reg =1 and v_cntr_reg =4) else
--             (3=> '1', others=>'0')         when (active = '1' and h_cntr_reg =1 and v_cntr_reg =5) else
--             (others=>'0');



  vga_red <=  (others=>'1')         when (active = '1' and ((h_cntr_reg <=127) or (h_cntr_reg <= 383 and h_cntr_reg >=256) or (h_cntr_reg >=512 and h_cntr_reg <=639))
                                                       and ((v_cntr_reg <=95) or (v_cntr_reg >=192 and v_cntr_reg <=287) or (v_cntr_reg >=384 and v_cntr_reg <=479)))
                                       
                                          else
              (others=>'1')        when (active = '1' and ((h_cntr_reg >= 128 and h_cntr_reg <=255) or (h_cntr_reg >=384 and h_cntr_reg <=511))
                                                       and ((v_cntr_reg >=96 and v_cntr_reg <=191) or (v_cntr_reg >=288 and v_cntr_reg <=383)))               
                                          else
              (others=>'0');
                
--  vga_blue <=  (others=>'1')         when (active = '1' and ((h_cntr_reg <=127) or (h_cntr_reg <= 383 and h_cntr_reg >=256) or (h_cntr_reg >=512 and h_cntr_reg <=639))
--                                                       and ((v_cntr_reg <=95) or (v_cntr_reg >=192 and v_cntr_reg <=287) or (v_cntr_reg >=384 and v_cntr_reg <=479)))
                                       
--                                          else
--              (others=>'1')        when (active = '1' and ((h_cntr_reg >= 128 and h_cntr_reg <=255) or (h_cntr_reg >=384 and h_cntr_reg <=511))
--                                                       and ((v_cntr_reg >=96 and v_cntr_reg <=191) or (v_cntr_reg >=288 and v_cntr_reg <=383)))               
--                                          else
--              (others=>'0');
--  vga_green <=  (others=>'1')         when (active = '1' and ((h_cntr_reg <=127) or (h_cntr_reg <= 383 and h_cntr_reg >=256) or (h_cntr_reg >=512 and h_cntr_reg <=639))
--                                                       and ((v_cntr_reg <=95) or (v_cntr_reg >=192 and v_cntr_reg <=287) or (v_cntr_reg >=384 and v_cntr_reg <=479)))
                                       
--                                          else
--              (others=>'1')        when (active = '1' and ((h_cntr_reg >= 128 and h_cntr_reg <=255) or (h_cntr_reg >=384 and h_cntr_reg <=511))
--                                                       and ((v_cntr_reg >=96 and v_cntr_reg <=191) or (v_cntr_reg >=288 and v_cntr_reg <=383)))               
--                                          else
--              (others=>'0');
 
         
 
 

  
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
 
  process (clk)
  begin
    if (rising_edge(clk)) then
      if (h_cntr_reg = (H_MAX - 1)) then
        h_cntr_reg <= (others =>'0');
      else
        h_cntr_reg <= h_cntr_reg + 1;
      end if;
    end if;
  end process;
  
  process (clk)
  begin
    if (rising_edge(clk)) then
      if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
        v_cntr_reg <= (others =>'0');
      elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
      end if;
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
      if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
        v_sync_reg <= V_POL;
      else
        v_sync_reg <= not(V_POL);
      end if;
    end if;
  end process;
  
  
  active <= '1' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else
            '0';


data<= (vga_red);


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


    end if;
  end process;

 active_o <= active;

end Behavioral;

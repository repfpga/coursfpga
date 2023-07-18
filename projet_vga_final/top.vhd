library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
--use ieee.std_logic_arith.all;

entity image_process is
generic (
			constant data_width : integer := 8;
            constant addr_cnt	: integer := 22	;
			constant img_width	: integer := 800;
			constant img_height	: integer := 525;
			constant rom_depth	: integer := 800*525;
			constant alt_tap_3_3	: integer := 800-2;  
			constant window_size_3_3 : integer := 3
			
						
);
port (
		clk : in std_logic;
		--en : in std_logic;
		resetn : in std_logic;		
		VGA_HS_O : out  STD_LOGIC;
        VGA_VS_O : out  STD_LOGIC;
        VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
        VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
        VGA_G : out  STD_LOGIC_VECTOR (3 downto 0)
		
	  );
end image_process;

architecture behavior of image_process is

------------
---------- PARTIE POUR IMAGE INPUT -------------

	component generateur_pattern	
		
    port(
			clk : in std_logic;
			active_o : out std_logic;
			data : out std_logic_vector(3  downto 0)
        );
    end component;		

component clk_wiz_0
port
 (-- Clock in ports
  CLK_in1           : in     std_logic;
  RESET             : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  locked            : out    std_logic
 );
end component;
	component rom_ctl is
	generic (
				data_width  : integer ;
				addr_cnt	: integer ;
				img_width	: integer ;
				rom_depth	: integer ;
				img_height	: integer 
	);
	port (
			clk : in std_logic;
			en  : in std_logic;
			resetn : in std_logic;
			addr : out std_logic_vector(addr_cnt-1 downto 0);
			pix_addr : out std_logic_vector(addr_cnt-1 downto 0);
			stream_on : out std_logic;
			col : out std_logic_vector(addr_cnt -1 downto 0);
			row : out std_logic_vector(addr_cnt -1 downto 0)
		);
	end component;
	-----------------------
	--------------- FINI PARTIE IMAGE INPUT-------
	----------------------------
	
	
	component gaussian_filter is
	generic (
				constant data_width : integer ;
				constant addr_cnt	: integer 	;
				constant img_width	: integer ;
				constant img_height	: integer;
				constant rom_depth	: integer ;
				constant alt_tap_3_3	: integer ;
				constant window_size_3_3 : integer
				
	);
	port (
			clk : in std_logic;
			resetn : in std_logic;		
			en	: in std_logic;
			stream_on : in std_logic;
			din: in std_logic_vector(data_width - 1 downto 0);			
			stream_out : out std_logic;
			dout : out std_logic_vector(data_width-1 downto 0);
			re_tap1: out std_logic
		);
	end component;

component VGA_driver is
  Port ( CLK : in  STD_LOGIC;
          RESET_I: in STD_LOGIC;
           DATA_I   : in STD_LOGIC_VECTOR (3 DOWNTO 0);
           gaussian_valid_i: in std_logic;
           VGA_HS_O : out  STD_LOGIC;
           VGA_VS_O : out  STD_LOGIC;
           VGA_R : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_B : out  STD_LOGIC_VECTOR (3 downto 0);
           VGA_G : out  STD_LOGIC_VECTOR (3 downto 0));
          end component;

	signal s_ctl_en: std_logic;	
	signal s_rom_addr : std_logic_vector(addr_cnt -1  downto 0);
    signal s_data : std_logic_vector (3 downto 0);
	signal  s_data_rom: std_logic_vector(data_width -1 downto 0);
	signal s_stream_on : std_logic;
	
	signal s_gaussian_valid, gaussian_valid : std_logic;
	signal s_gaussian_data : std_logic_vector(data_width - 1 downto 0);
	signal gaussian_data : std_logic_vector(3 downto 0);
     signal locked, plx_clk       : std_logic;
     signal s_enable : std_logic :='0';
     signal re_tap1 : std_logic;
    signal s_vga_hs_o: std_logic;
    signal active: std_logic;
begin
--resetn <=  not (rst);
	clk_div_inst : clk_wiz_0
  port map
   (-- Clock in ports
    CLK_in1 => CLK,
    RESET   => resetn,
    -- Clock out ports
    CLK_OUT1 => plx_clk,
    locked   => locked);
	

	
	img: generateur_pattern	
	
	port map (
          clk => plx_clk,
          active_o => active,
         -- addr => s_rom_addr,
		  data => s_data
    );
    s_data_rom<= "0000"& s_data;
	img_read : rom_ctl
	generic map(
		data_width	=> data_width,
		addr_cnt	=> addr_cnt,
		img_width	=> img_width,
		img_height 	=> img_height,
		rom_depth	=> rom_depth
	)
	port map(
		clk => plx_clk,
		resetn => resetn,
	--	en 	=> s_ctl_en,
	    en => active,
		stream_on => s_stream_on,
		addr => s_rom_addr
	);
	
	gaussian : gaussian_filter
	generic map(
			data_width	=> data_width,
			addr_cnt	=> addr_cnt,
			img_width	=> img_width,
			img_height 	=> img_height,
			rom_depth	=> rom_depth,
			alt_tap_3_3	=> alt_tap_3_3,
			window_size_3_3	=> window_size_3_3
	)
	port map(
		clk	=> plx_clk,
		resetn => resetn,
		--en	=> s_ctl_en,
		en => active,
		stream_on => s_stream_on,
		din => s_data_rom,
		stream_out => s_gaussian_valid,
		dout	=> s_gaussian_data,
		re_tap1 => re_tap1
	);
	
	gaussian_valid <= s_gaussian_valid;
	gaussian_data <= std_logic_vector(resize(unsigned(s_gaussian_data), 4));
    vga_hs_o <= s_vga_hs_o;
	VGA: VGA_driver
	port map(
	        CLK => plx_clk,
            RESET_I => resetn,
            gaussian_valid_i => s_enable,
           DATA_I   => gaussian_data,
           VGA_HS_O => s_VGA_HS_O,
           VGA_VS_O => VGA_VS_O,
           VGA_R => VGA_R,
           VGA_B => VGA_B,
           VGA_G => VGA_G
	);
	
	process (s_gaussian_valid)
	begin
	if (rising_edge(s_gaussian_valid)) then
	s_enable <= '1';
	end if;
	end process;
	
	
end behavior;


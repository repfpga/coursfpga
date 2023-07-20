library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	generic(
		constant PX_SIZE : integer := 8 ;       -- taille d'un pixel
		constant addr_cnt	: integer := 24	;     --- log2(8*1531*1080)=23.6
		constant img_width	: integer := 1531;
		constant img_height	: integer := 1080;
		constant rom_depth	: integer := 1531*1080;    
		constant alt_tap_3_3	: integer := 1531-2;  
		constant window_size_3_3 : integer := 3
	);
	port(
		resetn	: in std_logic;
		clk		: in std_logic;
		input_data	        : in std_logic_vector(PX_SIZE-1 downto 0);
		input_data_valid	: in std_logic;
		output_data	        : out std_logic_vector(PX_SIZE-1 downto 0);
		output_data_valid	: out std_logic
	);
end top;





architecture rtl of top is

component rom_ctl is
	generic (
				data_width   : integer ;
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
	
	
	component Sobel_filter is
	generic (
				constant data_width  : integer ;
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
			din: in std_logic_vector(data_width  - 1 downto 0);			
			stream_out : out std_logic;
			dout : out std_logic_vector(data_width -1 downto 0);
			pxl_ct  : out std_logic_vector(data_width-1 downto 0)
		);
	end component;
	
	signal s_ctl_en: std_logic;	
	signal s_rom_addr : std_logic_vector(addr_cnt -1  downto 0);
    signal s_data : std_logic_vector (3 downto 0);
	signal  s_data_rom: std_logic_vector(PX_SIZE -1 downto 0);
	signal s_stream_on : std_logic;
	
	signal s_gaussian_valid, gaussian_valid : std_logic;
	signal s_gaussian_data : std_logic_vector(PX_SIZE - 1 downto 0);
	signal gaussian_data : std_logic_vector(3 downto 0);
    -- signal locked,       : std_logic;
     signal s_enable : std_logic :='0';
     signal re_tap1 : std_logic;
    signal s_vga_hs_o: std_logic;
    signal active: std_logic;
    signal  pxl_ct  :  std_logic_vector( PX_SIZE - 1 downto 0);
begin
img_read : rom_ctl
generic map(
		data_width	=> PX_SIZE,
		addr_cnt	=> addr_cnt,
		img_width	=> img_width,
		img_height 	=> img_height,
		rom_depth	=> rom_depth
	)
	port map(
		clk => clk,
		resetn => resetn,
	    en => input_data_valid ,
		stream_on => s_stream_on,
		addr => s_rom_addr
	);
	
	Sobel : Sobel_filter
	generic map(
			data_width	=> PX_SIZE,
			addr_cnt	=> addr_cnt,
			img_width	=> img_width,
			img_height 	=> img_height,
			rom_depth	=> rom_depth,
			alt_tap_3_3	=> alt_tap_3_3,
			window_size_3_3	=> window_size_3_3
	)
	port map(
		clk	=> clk,
		resetn => resetn,
		en	=> input_data_valid,
		--en => active,
		stream_on => s_stream_on,
		din => input_data,
		stream_out => s_gaussian_valid,
		dout	=> s_gaussian_data,
		pxl_ct => pxl_ct
	);
	
	process(clk, resetn)
	begin
	if(resetn='1') then
			output_data <= (others => '0');
			output_data_valid <= '0';
		elsif(rising_edge(clk)) then 
		    if(s_gaussian_valid = '1') then
			   output_data <= s_gaussian_data;
			   --output_data <= pxl_ct;
			   output_data_valid <= '1';
			end if;
		end if;
	end process;

end architecture;
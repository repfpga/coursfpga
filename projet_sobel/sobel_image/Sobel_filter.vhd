library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Sobel_filter is
generic (
			constant data_width : integer ;
            constant addr_cnt	: integer 	;
			constant img_width	: integer ;
			constant img_height	: integer ;
			constant rom_depth	: integer ;
			constant alt_tap_3_3	: integer ;
			constant window_size_3_3 : integer 
			
);
port (
		clk : in std_logic;
		resetn : in std_logic;		
		en	: in std_logic;
		--en_fil : in std_logic;
		stream_on : in std_logic;
		din: in std_logic_vector(data_width - 1 downto 0);
		re_tap1 : out std_logic;
		stream_out : out std_logic;
	    
		dout : out std_logic_vector(data_width-1 downto 0);
		pxl_ct  : out std_logic_vector(data_width-1 downto 0)
	  );
end Sobel_filter;

architecture Sobel of Sobel_filter is

	component shift_tab_3_3
	generic (
			data_width	:	integer ;
            addr_cnt	:	integer ;
			alt_tap		:	integer;
			img_width	:	integer;
			img_height	:	integer	;		
			window_size :	integer;
			rom_depth	: integer
	);	
	port (
			clk : in std_logic;
			en : in std_logic;
			resetn : in std_logic;
			din : in std_logic_vector(data_width-1 downto 0);
			stream_on : in std_logic;
			r33, r32, r31, r23,r22,r21,r13,r12,r11 : out std_logic_vector(data_width-1 downto 0);
			pix_data_valid: out std_logic;
			pix_col : out std_logic_vector(addr_cnt -1 downto 0);
			pix_row : out std_logic_vector(addr_cnt -1 downto 0);
			pix_addr: out std_logic_vector(addr_cnt - 1 downto 0)
			
					
	  );
	end component;
	

	
	component Sobel_hs is
	generic (
				constant data_width : integer := 8;
				constant addr_cnt	:integer := 24
	);
	port (
			clk : in std_logic;
			resetn : in std_logic;
		--	en: in std_logic;
			r33, r32, r31, r23,r22,r21,r13,r12,r11 : in std_logic_vector(data_width-1 downto 0);
			in_data_valid : in std_logic;
			out_data_valid : out std_logic;
			dout : out std_logic_vector(data_width-1 downto 0)
		);
	end component;
	
	component Sobel_vs is
	generic (
				constant data_width : integer := 8;
				constant addr_cnt	:integer := 24
	);
	port (
			clk : in std_logic;
			resetn : in std_logic;
		--	en: in std_logic;
			r33, r32, r31, r23,r22,r21,r13,r12,r11 : in std_logic_vector(data_width-1 downto 0);
			in_data_valid : in std_logic;
			out_data_valid : out std_logic;
			dout : out std_logic_vector(data_width-1 downto 0)
		);
	end component;
	
	signal s_stream_on, s_stream_out :std_logic;
	signal s_data_valid : std_logic;
	signal s_din, s_dout : std_logic_vector(data_width - 1 downto 0);
	signal s_r33, s_r32, s_r31: std_logic_vector(data_width-1 downto 0);
	signal s_r23, s_r22, s_r21: std_logic_vector(data_width-1 downto 0);
	signal s_r13, s_r12, s_r11: std_logic_vector(data_width-1 downto 0);
	signal s_dout_hs     :  std_logic_vector(data_width - 1 downto 0);
	signal s_dout_vs     :  std_logic_vector(data_width - 1 downto 0);
begin
	
	s_stream_on <= stream_on;
	stream_out <= s_stream_out;
	s_din <= din;
	s_dout <= s_dout_vs+s_dout_hs;
	pxl_ct <= s_r22;
	window_3_3: shift_tab_3_3
	generic map(
			data_width	=> data_width,
			addr_cnt	=> addr_cnt,
			img_width	=> img_width,
			img_height 	=> img_height,
			rom_depth	=> rom_depth,
			alt_tap		=> alt_tap_3_3,
			window_size	=> window_size_3_3
	)
	port map(
		clk => clk,
		resetn => resetn,
		en 	=> en,
		din => s_din,
		stream_on => s_stream_on,
		r33	=>	s_r33, 
		r23	=>	s_r23, 		
		r13	=>	s_r13, 		
		r32	=>	s_r32, 
		r22	=>	s_r22, 
		r12	=>	s_r12, 
		r31	=>	s_r31,
		r21 =>  s_r21,
		r11 =>  s_r11,
		pix_data_valid => s_data_valid
		
	);
	
	Sobel_filter_hs: Sobel_hs 
	generic map(
			data_width	=> data_width,
			addr_cnt	=> addr_cnt
	)
	port map(
			clk => clk,
			resetn => resetn,
		--	en 	=> en,
			r33	=>	s_r33, 
			r23	=>	s_r23, 		
			r13	=>	s_r13, 		
			r32	=>	s_r32, 
			r22	=>	s_r22, 
			r12	=>	s_r12, 
			r31	=>	s_r31,
			r21 =>  s_r21,
			r11 =>  s_r11,

			in_data_valid => s_data_valid,
			out_data_valid => s_stream_out,
			dout => s_dout_hs
		
		);
		
		Sobel_filter_vs: Sobel_vs 
	generic map(
			data_width	=> data_width,
			addr_cnt	=> addr_cnt
	)
	port map(
			clk => clk,
			resetn => resetn,
		--	en 	=> en,
			r33	=>	s_r33, 
			r23	=>	s_r23, 		
			r13	=>	s_r13, 		
			r32	=>	s_r32, 
			r22	=>	s_r22, 
			r12	=>	s_r12, 
			r31	=>	s_r31,
			r21 =>  s_r21,
			r11 =>  s_r11,

			in_data_valid => s_data_valid,
			out_data_valid => s_stream_out,
			dout => s_dout_vs
		
		);
		----- process pour detecter le contour d'image --------
	----------------------------------------------	
		 process(clk, resetn)
	begin
		if resetn = '1' then
			dout <= (others =>'0');	
		elsif rising_edge(clk) then			
			if unsigned(s_dout) > 255 then
				dout <= "11111111";
			else
				dout <= s_dout;
			end if;
		end if;
	end process;
	----------------------------------------------------------	
	-------------- Process pour detecter des point d'intérets-------
	-----------------------------------------------------------------	
--		 process(clk, resetn)
--	begin
--		if resetn = '1' then
--			dout <= (others =>'0');	
--		elsif rising_edge(clk) then			
--			if unsigned(s_dout) > 65 then
--				dout <= "11111111";
--			else
--				dout <= "00000000";
--			end if;
--		end if;
--	end process;
	-----------------------------------------------------------------
	------------------------------------------------------------------	
end Sobel;

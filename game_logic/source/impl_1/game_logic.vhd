library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--b namespace: brick
--c namespace: cannon

entity game_logic is
	generic(N_ROWS : integer := 14;
			ROW_BITS : integer := 4;
	        N_COLS : integer := 20;
			COL_BITS : integer := 5
	);
    port(
		clk : in std_logic;
		c_pos : in unsigned(5 downto 0);
		c_fire : in std_logic
    );
end game_logic;

architecture synth of game_logic is
	component counter is
		generic(N_BITS : integer := 4);
		port(
			clk : in std_logic;
			reset : in std_logic;
			count : out std_logic_vector(N_BITS - 1 downto 0)
		);
	end component;
	
	component ram is
		generic(N_ADDR : integer := ROW_BITS; 
				DAT_WID : integer := N_COLS
		);
		
		port(
			clk : in std_logic;
			wr_en : in std_logic;
			addr : in std_logic_vector(N_ADDR - 1 downto 0);
			data_wr : in std_logic_vector(DAT_WID - 1 downto 0);
			data_rd : out std_logic_vector(DAT_WID - 1 downto 0)
		);
	end component;
	
	component lfsr is
	generic(N_BITS : integer := N_COLS);
	  port(
		  clk : in std_logic;
		  reset : in std_logic;
		  count : out std_logic_vector(N_BITS - 1 downto 0)
	  );
	end component;
	
	signal b_idx_reset : std_logic := '0';
	signal b_idx : std_logic_vector(ROW_BITS - 1 downto 0);
	signal b_data : std_logic_vector(N_COLS - 1 downto 0);
	
	signal b_wr_en : std_logic := '1';
	signal b_rd : std_logic_vector(N_COLS - 1 downto 0);
begin
	b_count : counter port map(clk => clk, reset => b_idx_reset, count => b_idx);
	b_gen : lfsr port map(clk => clk, reset => '0', count => b_data);
	b_mem : ram port map(clk => clk, wr_en => b_wr_en, addr => b_idx, data_wr => b_data, data_rd => b_rd);
end;
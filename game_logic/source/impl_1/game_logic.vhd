library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- g namepsace: game
-- b namespace: brick
-- c namespace: cannon

entity game_logic is
	generic(
		N_ROWS : integer := 14;
		ROW_BITS : integer := 4;
		N_COLS : integer := 20;
		COL_BITS : integer := 5
	);
	
    port(
		data : in std_logic;
		g_clk : in std_logic; -- how fast game is updated
		b_clk : in std_logic; -- how fast we generate new bricks
		game_over : out std_logic
    );
end game_logic;

architecture synth of game_logic is	
	component ram is
		generic(
			N_ADDR : integer := ROW_BITS; 
			DAT_WID : integer := N_COLS;
			DAT_BITS : integer := COL_BITS
		);
		
		port(
			clk : in std_logic;
			addr : in std_logic_vector(N_ADDR - 1 downto 0);
			wr_en : in std_logic;
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
	
	component cannon is
		generic(N_BITS : integer := COL_BITS);
		port(
			data : in std_logic;
			fire : out std_logic;
			position : out unsigned(N_BITS - 1 downto 0) := (others => '0')
		);
	end component;
	
	
	signal b_nxt_row : std_logic_vector(N_COLS - 1 downto 0);
	signal b_count : unsigned(ROW_BITS - 1 downto 0);
		
	signal b_wr_en : std_logic := '0';
	signal b_addr : std_logic_vector(ROW_BITS - 1 downto 0);
	signal b_wr : std_logic_vector(N_COLS - 1 downto 0);
	signal b_rd : std_logic_vector(N_COLS - 1 downto 0);
	
	signal c_pos : unsigned(COL_BITS - 1 downto 0);
	signal c_fire : std_logic;
	signal c_nxt_fire : std_logic := '0';
	
	signal g_count : unsigned(7 downto 0);
begin
	b_mem : ram port map(clk => g_clk, wr_en => b_wr_en, addr => b_addr, data_wr => b_wr, data_rd => b_rd);
	b_generator : lfsr port map(clk => b_clk, reset => '0', count => b_nxt_row);
	c_controller : cannon port map(data => data, fire => c_fire, position => c_pos);
	
	process (g_clk) begin
		if rising_edge(g_clk) then
			if c_fire = '1' then -- check if we are firing the cannon
				for i in 0 to (N_COLS - 1) loop
					b_addr <= std_logic_vector(to_unsigned(i, ROW_BITS));
					if b_rd(to_integer(c_pos)) = '1' then -- we found a block
						b_wr_en <= '1';
						b_wr <= std_logic_vector(to_unsigned(0, N_COLS)); -- delete the block
						b_wr_en <= '0';
					end if;
				end loop;
				
				b_addr <= std_logic_vector(b_count);
				if b_rd = std_logic_vector(to_unsigned(0, N_COLS)) then -- check if the top row has no blocks
					b_count <= b_count - to_unsigned(1, ROW_BITS);
				end if;
			end if;
			
			g_count <= g_count + to_unsigned(1, 8);
			
			if g_count = to_unsigned(255, 8) then
				if (b_count = to_unsigned(N_ROWS - 1, ROW_BITS)) then -- when all rows fill with bricks, end game
					game_over <= '1';
				else 
					b_count <= b_count + to_unsigned(1, ROW_BITS);
					b_addr <= std_logic_vector(b_count);
					b_wr_en <= '1';
					b_wr <= b_nxt_row; -- write next row of blocks to memory
					b_wr_en <= '0';
				end if;
				
				g_count <= to_unsigned(0, 8);
			end if;
		end if;
	end process;
end;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
    CLK_12M: in std_logic; --12M input clock 
    Hsync: out std_logic;
    Vsync: out std_logic;
    ground: out std_logic;
    out_0: out std_logic;
    rgb_out: out std_logic
  );
end top;

architecture synth of top is 

    component pll is
        port (
            clk_in : in std_logic;
            clk_out : out std_logic;
            clk_locked : out std_logic
        );
    end component;

    component vga is
        port(
            pixel_clk: in std_logic; --25M clk 
            HSYNC: out std_logic;
            VSYNC: out std_logic;
            row_count: out unsigned( 9 downto 0);
            valid: out std_logic;
            column_count: out unsigned( 9 downto 0)
        );
    end component;

    component display is
        port(
            rgb: out std_logic;
            row: in unsigned(9 downto 0);
            column: in unsigned(9 downto 0);
            valid: in std_logic;
        
            column_in: in unsigned(4 downto 0);
            data_in: in std_logic_vector(31 downto 0)
        );
    end component;

    -- component brick_ram is
    --     GENERIC
    --     (
    --         ADDRESS_WIDTH	: integer := 5;
    --         DATA_WIDTH	    : integer := 32
    --     );
    --     PORT
    --     (
    --         clock			: IN  std_logic;
    --         data			: IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
    --         write_address	: IN  std_logic_vector(ADDRESS_WIDTH - 1 DOWNTO 0);
    --         read_address	: IN  std_logic_vector(ADDRESS_WIDTH - 1 DOWNTO 0);
    --         we			    : IN  std_logic;
    --         q			    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
    --     );
    -- end component;

    TYPE ram_brick IS ARRAY(0 TO 2 ** 5 - 1) OF std_logic_vector(32 - 1 DOWNTO 0);
	SIGNAL ram_block : ram_brick := (0 => 32d"1024", 1 => 32d"1028", others => (others => '0'));
    

    signal rowCount: unsigned( 9 downto 0);
    signal colCount: unsigned( 9 downto 0);
    signal valid:  std_logic;

    signal row_clk: std_logic;
    signal ram_address: unsigned(4 downto 0);
    signal column_out: unsigned(4 downto 0);
    signal brick_out: std_logic_vector(31 downto 0);

    -- cannonball/cannon 
    signal cannon_row: unsigned( 9 downto 0 );
    signal cannon_col: unsigned( 9 downto 0 );
    
  
begin

    ram_address <= rowCount(9 downto 5);
    column_out <= colCount(9 downto 5);
    

    PLL1: pll
    port map(
        clk_in => CLK_12M,
        clk_out => out_0,
        clk_locked => open
    );

    VGA1: vga
    port map(
        pixel_clk => out_0,
        HSYNC => Hsync,
        VSYNC => Vsync,
        row_count => rowCount,
        column_count => colCount,
        valid => valid
    );

    DISPLAY1: display
    port map(
        rgb => rgb_out,
        row => rowCount,
        column => colCount,
        column_in => column_out,
        valid => valid,
        data_in => brick_out
    );

    row_clk <= '1' when colCount > 10d"640" else '0';
    process(row_clk)
    begin
        if(rising_edge(row_clk)) then
            brick_out <= ram_block(to_integer(ram_address));
        end if;
    end process;

    -- cannonball


    -- brick_ram1: brick_ram
    -- port map(
    --     clock =>  row_clk,
    --     data => "00000000001000000000" & 12d"0",
    --     write_address => "00000",
    --     read_address => std_logic_vector(ram_address),
    --     we => '0',
    --     q => brick_out
    -- );

    ground <= '0';
end;

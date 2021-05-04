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
    rgb_out: out std_logic; 
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
            column_count: out unsigned( 9 downto 0);
            -- To the brick gen; 
            rowclk: out std_logic;
            address: out unsigned(9 downto 5);
            col_out out unsigned(9 downto 5)
          );
    end component;

    component display is
        port(
            rgb: out std_logic;
            row: in unsigned(9 downto 0);
            valid: in std_logic;
            column: in unsigned(9 downto 5);
            data_in: in std_logic_vector(31 downto 0)
          );
    end component;

    component brick_ram is
        GENERIC
        (
            ADDRESS_WIDTH	: integer := 5;
            DATA_WIDTH	: integer := 32
        );
        PORT
        (
            clock			: IN  std_logic;
            data			: IN  std_logic_vector(DATA_WIDTH - 1 DOWNTO 0);
            write_address	: IN  std_logic_vector(ADDRESS_WIDTH - 1 DOWNTO 0);
            read_address	: IN  std_logic_vector(ADDRESS_WIDTH - 1 DOWNTO 0);
            we			    : IN  std_logic;
            q			    : OUT std_logic_vector(DATA_WIDTH - 1 DOWNTO 0)
        );
    end component;

    
    signal rowCount: unsigned( 9 downto 0);
    signal colCount: unsigned( 9 downto 0);
    signal display:  std_logic;
    signal row_CLK: std_logic;
    signal addrss: unsigned(9 downto 5);
    signal column_out: unsigned(9 downto 5);

    signal tmp_data : std_logic_vector(31 downto 0);
    signal tmp_write_address : std_logic_vector(4 downto 0);
    signal tmp_read_address : std_logic_vector(4 downto 0);
    signal tmp_we : std_logic;
    signal brick_out : std_logic_vector(31 downto 0);
  
begin

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
        valid => display,
        -- To the brick gen; 
        rowclk => row_CLK,
        address => addrss,
        col_out => column_out
    );

    display1: display
    port map(
        rgb => rgb_out,
        row => rowCount,
        column => colCount,
        valid => display,
        data_in => brick_out
    );

    brick_ram1: brick_ram
    port map(
        clock => row_CLK,
        data => tmp_data,
        write_address => tmp_write_address,
        read_address => tmp_read_address,
        we => tmp_we,
        q => brick_out
    );

    ground <= '0';
end;

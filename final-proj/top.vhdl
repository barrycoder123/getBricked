library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
    CLK_12M: in std_logic; --12M input clock 
    controller_data: in std_logic;
    Hsync: out std_logic;
    Vsync: out std_logic;
    ground: out std_logic;
    out_0: out std_logic;
    rgb_out: out std_logic;
    test: out std_logic
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
            pixel_clk: in std_logic;
            rgb: out std_logic;
            row: in unsigned(9 downto 0);
            column: in unsigned(9 downto 0);
            valid: in std_logic;
        
            column_in: in unsigned(4 downto 0);
            data_in: in std_logic_vector(31 downto 0);

            -- -- cannonball
            cannon_row: in unsigned( 9 downto 0);
            cannon_col: in unsigned( 9 downto 0);

            --canon
            cannonPos: in unsigned( 9 downto 0)
        );
    end component;

    component cannon is
        port(
            frame_clk: in std_logic;
            data : in std_logic;
            fire : out std_logic;
            position : out unsigned(9 downto 0) := (others => '0')
        );
    end component;

    TYPE ram_brick IS ARRAY(0 TO 2 ** 5 - 1) OF std_logic_vector(32 - 1 DOWNTO 0);
	SIGNAL ram_block : ram_brick := (0 => (others => '1'), others => (others => '0'));
    

    signal rowCount: unsigned( 9 downto 0);
    signal colCount: unsigned( 9 downto 0);
    signal valid:  std_logic;

    signal row_clk: std_logic;
    signal ram_address: unsigned(4 downto 0);
    signal column_out: unsigned(4 downto 0);
    signal brick_out: std_logic_vector(31 downto 0);

    -- cannonball/cannon 
    signal cannon_row: unsigned( 9 downto 0 ) := "0111000100";
    --signal cannon_col: unsigned( 9 downto 0 ) := "0010000000";
    signal frame_clk: std_logic;
    signal frame_count: unsigned(5 downto 0) := "000000";

    --NES
    signal fire_sig : std_logic;
    signal pos_sig : unsigned(9 downto 0);

    
  
begin

    ram_address <= rowCount(9 downto 5);
    column_out <= colCount(9 downto 5);
    

    PLL1: pll
    port map(
        clk_in => CLK_12M,
        clk_out => out_0,
        clk_locked => test
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
        pixel_clk => out_0,
        rgb => rgb_out,
        row => rowCount,
        column => colCount,
        column_in => column_out,
        valid => valid,
        data_in => brick_out,

        -- -- cannon ball
        cannon_row => cannon_row,
        cannon_col => pos_sig,

        --cannon
        cannonPos => pos_sig
    );

    CANNON1: cannon
    port map(
        frame_clk => frame_clk,
        data => controller_data,
        fire => fire_sig,
        position => pos_sig
    );

    row_clk <= '1' when colCount > 10d"640" else '0';
    process(row_clk)
    begin
        if(rising_edge(row_clk)) then
            brick_out <= ram_block(to_integer(ram_address));
        end if;
    end process;

    -- -- cannonball
    frame_clk <= '1' when rowCount > 10d"480" else '0';
    process(frame_clk)
    begin
        if (rising_edge(frame_clk)) then
            frame_count <= frame_count + 1;
            if (frame_count = 16) then
                cannon_row <= cannon_row - 8;
                frame_count <= "000000";
            end if;
        end if;
    end process;

    -- -- cannon
    -- process(frame_clk)
    -- begin
    --     if (rising_edge(frame_clk)) then
    --         frame_count <= frame_count + 1;
    --         if (frame_count = 16) then
                
    --             frame_count <= "000000";
    --         end if;
    --     end if;
    -- end process;


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
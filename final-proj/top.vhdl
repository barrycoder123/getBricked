library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is
  port(
    CLK_12M: in std_logic; --12M input clock 
    controller_data: in std_logic;
    nes_clk: out std_logic;
    nes_latch: out std_logic;
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
            cannon_row: in unsigned( 9 downto 0); --technically equivalent ball_pos 
            cannon_col: in unsigned( 9 downto 0);

            --canon
            cannonPos: in unsigned( 9 downto 0)
        );
    end component;

    component cannon is
        port(
            frame_clk: in std_logic;
            data : in std_logic;
            nes_clk: out std_logic;
            nes_latch: out std_logic;
            fire : out std_logic;
            position : out unsigned(9 downto 0) := (others => '0');
            ball_pos : out unsigned(9 downto 0);
            ball_row : out unsigned(9 downto 0)
        );
    end component;

    TYPE ram_brick IS ARRAY(0 TO 2 ** 5 - 1) OF std_logic_vector(32 - 1 DOWNTO 0);
	SIGNAL ram_block : ram_brick := (0 =>  "00000000000011111100111100111111", 
                                     1 =>  "00000000000011111111111111111111",
                                     2 =>  "00000000000011111110000001111111",
                                     3 =>  "00000000000011111001111110011111",
                                     4 =>  "00000000000011110011111111001111",
                                     others => (others => '0'));
    

    signal rowCount: unsigned( 9 downto 0);
    signal colCount: unsigned( 9 downto 0);
    signal valid:  std_logic;

    signal row_clk: std_logic;
    signal ram_address: unsigned(4 downto 0);
    signal column_out: unsigned(4 downto 0);
    signal brick_out: std_logic_vector(31 downto 0);

    -- cannonball/cannon 
    signal cannon_row: unsigned( 9 downto 0 );
    signal cannonball_reset: unsigned(9 downto 0);
    
    --signal cannon_col: unsigned( 9 downto 0 ) := "0010000000";
    signal frame_clk: std_logic;
    signal frame_count: unsigned(5 downto 0) := "000000";

    --NES
    signal fire_sig : std_logic;
    signal ball_pos_sig:  unsigned(9 downto 0);
    signal cannon_pos_sig: unsigned( 9 downto 0);
    signal cannonPos_d: unsigned( 9 downto 0);

    
  
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
        cannon_col => ball_pos_sig,

        --cannon
        cannonPos => cannonPos_d
    );

    CANNON1: cannon
    port map(
        frame_clk => frame_clk,
        data => controller_data,
        nes_clk => nes_clk,
        nes_latch => nes_latch,
        fire => fire_sig,
        ball_pos => ball_pos_sig,
        position => cannon_pos_sig,
        ball_row => cannonball_reset
    );

    row_clk <= '1' when colCount > 10d"640" else '0';
    process(row_clk)
    begin
        if(rising_edge(row_clk)) then
            
            -- if(brick_out(to_integer(cannon_col(9 downto 5))) = '1') then

            -- end if;
            brick_out <= ram_block(to_integer(ram_address));

        end if;
    end process;
    
    -- -- cannonball/cannon
    frame_clk <= '1' when rowCount > 10d"480" else '0';
    process(frame_clk)
    VARIABLE cur_col: std_logic_vector(31 downto 0);
    begin
        if (rising_edge(frame_clk)) then
            frame_count <= frame_count + 1;
            if (frame_count = 4) then
                cannonPos_d <= cannon_pos_sig; --updating cannon position based on nes control
                cannon_row <= cannonball_reset; -- updating the cannonballpos
                             
                cur_col := ram_block(to_integer(cannonball_reset(9 downto 5)));

                if cur_col(to_integer(cannon_pos_sig(9 downto 5))) = '1' then
                    ram_block(to_integer(cannonball_reset(9 downto 5))) <= cur_col xor (32b"1" sll to_integer(cannon_pos_sig(9 downto 5)));-- use bit masking to change the ram blocks
                end if;
                
                frame_count <= "000000";
            end if;
        end if;
    end process;



    ground <= '0';
end;

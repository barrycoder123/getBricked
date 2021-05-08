library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pll is
    port (
        clk_in : in std_logic;
        clk_out : out std_logic;
        clk_locked : out std_logic
    );
end pll;

architecture synth of pll is

    component SB_PLL40_CORE is
        generic (

            -- Uncomment one of these to choose a resolution
            -- Make sure the VGA has the matching clk speed

            -- 48 MHz > 25.125 MHz / 480p
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0011";
            -- DIVF : unsigned(6 downto 0) := "1000010";
            -- DIVQ : unsigned(2 downto 0) := "101";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- 48 MHz > 65 MHz / 1024x768
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0010";
            -- DIVF : unsigned(6 downto 0) := "1000000";
            -- DIVQ : unsigned(2 downto 0) := "100";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- 48 MHz > 74 MHz / 720p Doesn't work
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0010";
            -- DIVF : unsigned(6 downto 0) := "0100100";
            -- DIVQ : unsigned(2 downto 0) := "011";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- 48 MHz > 86 MHz / 1368x768 Doesn't work
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0010";
            -- DIVF : unsigned(6 downto 0) := "0101010";
            -- DIVQ : unsigned(2 downto 0) := "011";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- 36 MHz > 65.25 MHz / 1024x768
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0000";
            -- DIVF : unsigned(6 downto 0) := "0011100";
            -- DIVQ : unsigned(2 downto 0) := "100";
            -- FILTER_RANGE : unsigned(2 downto 0) := "011"

            -- 36 MHz > 74.25 MHz / 720p
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0001";
            -- DIVF : unsigned(6 downto 0) := "0100000";
            -- DIVQ : unsigned(2 downto 0) := "011";
            -- FILTER_RANGE : unsigned(2 downto 0) := "010"

            -- 36 MHz > 148.5 MHz / 1080p
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0001";
            -- DIVF : unsigned(6 downto 0) := "0100000";
            -- DIVQ : unsigned(2 downto 0) := "010";
            -- FILTER_RANGE : unsigned(2 downto 0) := "010"

            -- 36 > 109 MHz / 1280x1024 / Black screen doesn't work
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0010";
            -- DIVF : unsigned(6 downto 0) := "1001000";
            -- DIVQ : unsigned(2 downto 0) := "011";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- 12 MHz > 25.125 MHz / 640x480
            FEEDBACK_PATH : String := "SIMPLE";
            DIVR : unsigned(3 downto 0) := "0000";
            DIVF : unsigned(6 downto 0) := "1000010";
            DIVQ : unsigned(2 downto 0) := "101";
            FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- 12 MHz > 49.5 MHz / 800x600
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0000";
            -- DIVF : unsigned(6 downto 0) := "1000001";
            -- DIVQ : unsigned(2 downto 0) := "100";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

            -- -- 12 MHz > 65 MHz / 1024x768
            -- FEEDBACK_PATH : String := "SIMPLE";
            -- DIVR : unsigned(3 downto 0) := "0000";
            -- DIVF : unsigned(6 downto 0) := "1010110";
            -- DIVQ : unsigned(2 downto 0) := "100";
            -- FILTER_RANGE : unsigned(2 downto 0) := "001"

        );
        port (
            LOCK : out std_logic;
            RESETB : in std_logic;
            BYPASS : in std_logic;
            REFERENCECLK : in std_logic;
            PLLOUTGLOBAL : out std_logic
        );
    end component;

begin

    dut1 : SB_PLL40_CORE port map (
        LOCK => clk_locked,
        RESETB => '1',
        BYPASS => '0',
        REFERENCECLK => clk_in,
        PLLOUTGLOBAL => clk_out
    );

end;

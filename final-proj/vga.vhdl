library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vga is
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
end vga;

architecture synth of vga is

begin
    --Counts the Rows and Columns 
    counter: process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then 
            if column_count >= 10d"799" then
                row_count <= row_count + '1';
                column_count <= 10d"0";
            elsif row_count >= 10d"524" then
                row_count <= 10d"0";
            else    
                column_count <= column_count + '1';
            end if;
        end if;
    end process;
    hsync <= '0' when column_count > 10d"655" and column_count < 10d"751" 
                 else '1';
    vsync <= '0' when row_count > 10d"489" and row_count < 10d"493" else '1';

    valid <= '1' when column_count < 10d"641" and row_count < 10d"481" 
    else '0';

    address <= row_count(9 downto 5);
    col_out <= column_count(9 downto 5);
    rowclk <= row_count(5);

end;

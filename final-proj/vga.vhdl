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
    column_count: out unsigned( 9 downto 0)
  );
end vga;

architecture synth of vga is

begin
    --Counts the Rows and Columns 
    counter: process(pixel_clk)
    begin
        if rising_edge(pixel_clk) then

            if column_count < 10d"799" then
                column_count <= column_count + '1';  
            else 
                if row_count < 10d"524" then
                    row_count <= row_count + '1';             
                else
                    row_count <= 10d"0";
                end if;
                column_count <= 10d"0";
            end if;
            if (column_count > 10d"655" and column_count < 10d"752") then 
              hsync <= '0';
            else
              hsync <= '1';
            end if;
            if (row_count > 10d"489" and row_count < 10d"492") then 
              vsync <= '0';
            else
              vsync <= '1';
            end if;

        end if;
    end process;
    -- hsync <= '0' when column_count > 10d"655" and column_count < 10d"752" 
    --             else '1';
    -- vsync <= '0' when row_count > 10d"489" and row_count < 10d"492" 
    --             else '1';
    valid <= '1' when column_count < 10d"639" and row_count < 10d"479" 
                else '0';

end;

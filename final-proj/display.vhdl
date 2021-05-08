library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display is
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

    --cannon
    cannonPos: in unsigned(9 downto 0)
  );
end display;


architecture synth of display is
  signal on_ball: std_logic:= '0';


begin
  process(pixel_clk)
  begin
    if(rising_edge(pixel_clk)) then
      if(valid = '1' and (( (data_in(to_integer(column_in)) = '1')) or 
                            (cannon_row <= row and (cannon_row + 16) > row and cannon_col <= column and (cannon_col + 16) > column) or --cannonball
                            (10d"448"<= row and (10d"448" + 32) > row and cannonPos <= column and (cannonPos + 32) > column) )) then --cannon
        rgb <= '1';
      else
        rgb <='0';
      end if;
    end if;
  end process;

end;

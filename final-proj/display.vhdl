library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display is
  port(
    rgb: out std_logic;
    row: in unsigned(9 downto 0);
    column: in unsigned(9 downto 0);
    valid: in std_logic;

    column_in: in unsigned(4 downto 0);
    data_in: in std_logic_vector(31 downto 0)
  );
end display;

architecture synth of display is

begin

  rgb <= '1' when valid = '1' and data_in(to_integer(column_in)) = '1' else '0';
  -- rgb <= '1' when valid = '1' and column < 10d"320" and row < 10d"480" else '0';


end;

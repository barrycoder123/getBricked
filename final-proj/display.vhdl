library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity display is
  port(
    rgb: out std_logic;
    row: in unsigned(9 downto 0);
    valid: in std_logic;
    column: in unsigned(9 downto 5);
    data_in: in std_logic_vector(31 downto 0)
  );
end display;

architecture synth of display is

begin

  rgb <= '1' when valid = '1' and data_in(column) = '1' else '0';

end;

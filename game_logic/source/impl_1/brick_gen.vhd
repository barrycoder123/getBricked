library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity brick_gen is
	generic(M : integer := 20);
    port(
		b_row : out std_logic_vector(M downto 0)
    );
end brick_gen;

architecture synth of brick_gen is
begin
end;
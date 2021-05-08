library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity counter is
	generic(N: integer := 17);
	port(
		clk : in std_logic;
		reset : in std_logic;
		q : out std_logic_vector(N - 1 downto 0) := (others => '0')
	);
end counter;
	
architecture synth of counter is
signal i : unsigned(N - 1 downto 0);
begin
	process(clk, reset) begin
		if (reset = '1') then 
			i <= to_unsigned(0, N);
		elsif rising_edge(clk) then 
			i <= i + to_unsigned(1, N);
		end if;
	end process;
	q <= std_logic_vector(i);
end;

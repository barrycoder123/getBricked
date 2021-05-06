library IEEE;
use IEEE.std_logic_1164.all;

entity lfsr is
generic(N_BITS : integer := 20);
	port(
		clk : in std_logic;
		reset : in std_logic;
		count : out std_logic_vector(N_BITS - 1 downto 0)
	);
end lfsr;

architecture synth of lfsr is
	signal i : std_logic_vector(N_BITS - 1 downto 0);
begin
	process(clk, reset) 
		variable tmp : std_logic := '0';
	begin
		if (reset = '1') then
			i <= 20b"1";
		elsif rising_edge(clk) then
			tmp := xor i;
			i <= tmp & i(N_BITS - 1 downto 1);
		end if;
	end process;
	count <= i;
end;
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cannon is
	generic(N_BITS : integer := 5);
    port(
		data : in std_logic;
		fire : out std_logic;
		position : out unsigned(N_BITS - 1 downto 0) := (others => '0')
    );
end cannon;

architecture synth of cannon is
	component nes is
	    port(
			data : in std_logic;
			data_out : out std_logic_vector(7 downto 0);
			NESclk : out std_logic;
			NEScount : out std_logic_vector(7 downto 0);
			latch : out std_logic;
			clock : out std_logic
		);
	end component;
	
	signal move_left : std_logic;
	signal move_right : std_logic;
	signal fire_tmp : std_logic;
begin
	cannon_controller : nes port map(data => data, data_out(0) => move_left, data_out(1) => move_right, data_out(7) => fire_tmp);
	fire <= not fire_tmp;
	process(move_left, move_right) begin
		if (move_right = '0') and (position /= "11111") then
			position <= position + to_unsigned(1, 5);
		elsif (move_left = '0') and (position /= "00000") then
			position <= position - to_unsigned(1, 5);
		end if;
	end process;

end;
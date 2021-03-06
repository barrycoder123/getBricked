library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cannon is 
    port(
		frame_clk: in std_logic;
		data : in std_logic;
		nes_clk: out std_logic;
		nes_latch: out std_logic;
		fire : out std_logic;
		position : out unsigned(9 downto 0) := (others => '0');
		ball_pos : out unsigned(9 downto 0);
		ball_row : out unsigned(9 downto 0)
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
	signal temp: std_logic_vector(4 downto 0) := "00000";
begin
	cannon_controller : nes port map(
		NESclk => nes_clk,
		latch => nes_latch,
		data => data, 
		data_out(0) => move_left, 
		data_out(1) => move_right, 
		data_out(7) => fire_tmp,
		data_out(6 downto 2) => temp
		);
	fire <= not fire_tmp;
	process(frame_clk) begin
		if((rising_edge(frame_clk))) then
			if (move_right = '0') and (position /= "1001100000") then
				position <= position + to_unsigned(1, 10);
			end if;
			if (move_left = '0') and (position /= "0000000000") then
				position <= position - to_unsigned(1, 10);
			end if;
			if fire_tmp = '0' then
				ball_pos <= position;
				if(ball_row > 10d"0") then
					ball_row <= ball_row - 16;
				end if;
			end if;
			if fire_tmp = '1' then
				ball_pos <= position;
				ball_row <= 10d"488";
			end if;
		end if;
	end process;

end;
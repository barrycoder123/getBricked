library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity brick_gen is
	port(
        outBrick: out std_logic_vector(19 downto 0)
	);
end brick_gen;

architecture synth of brick_gen is

    component lfsr is
        generic(
            seed: std_logic_vector(19 downto 0) := "00000000000000000001"
        );
        port(
            clk : in std_logic;
            reset : in std_logic;
            count : out std_logic_vector(19 downto 0)
        );
    end component;
    signal clk_temp, reset_temp: std_logic;

begin
    random_gen: lfsr 
    generic map(
        seed => "00000000000000000010"
    )
    port map (
        clk => clk_temp,
        reset => reset_temp,
        count => outBrick
    );
end;
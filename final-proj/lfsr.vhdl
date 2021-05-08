library IEEE;
use IEEE.std_logic_1164.all;

entity lfsr is
    generic(
        seed: std_logic_vector(19 downto 0) := 20d"1"
    );
    port(
        clk : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(19 downto 0)
    );
end lfsr;

architecture synth of lfsr is

signal feedback: std_logic;
signal temp: std_logic_vector(19 downto 0);

begin
    process (clk,reset)
    begin
        feedback <= temp(19) xor temp(0);
        if (reset='1') then
            temp <= seed;
        elsif (rising_edge(clk)) then
            temp <= temp(0) & feedback & temp(18 downto 1);
        end if;
    end process;
    count <= temp;
    
end;


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity nes is 
    port(
        data : in std_logic;
		data_out : out std_logic_vector(7 downto 0);
        NESclk : out std_logic;
        NEScount : out std_logic_vector(7 downto 0);
        latch : out std_logic;
        clock : out std_logic
    );
end nes;

architecture sim of nes is
    component HSOSC is
        generic (CLKHF_DIV : String := "0b00");
        port(
            CLKHFPU : in std_logic := 'X';
            CLKHFEN : in std_logic := 'X';
            CLKHF : out std_logic := '0');
	end component;
	
    component counter is
        generic(N: integer := 17);
        port(
            clk : in std_logic;
            reset : in std_logic;
            q : out std_logic_vector(N - 1 downto 0) := (others => '0')
        );
    end component;

    signal clk_d : std_logic;
    signal q_d : std_logic_vector(16 downto 0);
	signal temp : std_logic_vector(7 downto 0) := (others => '0');
	
begin
    HSOSC_C : HSOSC port map(CLKHFPU => '1', CLKHFEN => '1', CLKHF => clk_d);
    counter_C : counter port map(clk => clk_d, reset => '0', q => q_d);

    NESclk <= q_d(8);
    NEScount <= q_d(16 downto 9);
    latch <= '1' when NEScount = x"FF" else '0';
    clock <= NESclk when NEScount >= x"00" and NEScount < x"08" else '0';
	
	process(NESclk) begin
		if rising_edge(NESclk) and (NEScount >= x"00" and NEScount < x"08") then 
			temp <= temp(6 downto 0) & data;
		end if;
	end process;
	data_out <= temp;
end;
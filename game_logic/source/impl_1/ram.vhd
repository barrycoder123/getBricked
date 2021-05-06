library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
	generic(N_ADDR : integer := 4; 
	        DAT_WID : integer := 20
	);
	
    port(
		clk : in std_logic;
		wr_en : in std_logic;
		addr : in std_logic_vector(N_ADDR - 1 downto 0);
		data_wr : in std_logic_vector(DAT_WID - 1 downto 0);
		data_rd : out std_logic_vector(DAT_WID - 1 downto 0)
    );
end ram;

architecture synth of ram is
	type mem_ty is array((2 ** (N_ADDR - 1)) downto 0)
		of std_logic_vector(DAT_WID - 1 downto 0);
	
	signal mem : mem_ty := (others => (others => '0'));
begin
	process(clk) begin
		if rising_edge(clk) and wr_en = '1' then
			mem(to_integer(unsigned(addr))) <= data_wr;
		end if;
	end process;
	
	data_rd <= mem(to_integer(unsigned(addr)));
end;
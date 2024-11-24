library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use work.my_component.all;


entity tb_reg_dec is
end entity;

architecture arch_tb_reg_dec of tb_reg_dec is


component reg_dec is
	generic(
		N: integer:=8
	);
	port (
		clk,rst,input : in std_logic;
		output: out std_logic_vector (N-1 downto 0)
	);
end component;

signal input,rst:  std_logic;
signal clk:  std_logic:='0';
signal output:  std_logic_vector (31 downto 0);
signal data :std_logic_vector (0 to 33);
constant period :time := 100 ns;

begin
	data <="1011011100001001001001001010000100";
	rd: reg_dec generic map (32)port map(clk,rst,input,output);
	
	rst <= '1', '0' after period;
	
	clk <= not clk after period/2;
	
	process
	begin
	 for i in 0 to 256 loop
		input<=data(i);
 		--clk<='1';
		wait for period;
		--clk<='0';
		--wait for 50 ns;
	 end loop;
	end process;
	
end arch_tb_reg_dec;

library ieee;
use ieee.std_logic_1164.all;

entity reg_dec is
	generic(
		N: integer:=8
	);
	port (
		clk,rst,input : in std_logic;
		output: out std_logic_vector (N-1 downto 0)
	);
end entity;

--commentaire

architecture arch_reg_dec of reg_dec is
--use work.my_component.all;
component bas_d is
	port (
		clk,rst,d : in std_logic;
		q: out std_logic
	);
end component;
signal tmp : std_logic_vector (N-1 downto 0);
begin
output<=tmp;
--tmp(0)<=input;
bd0: bas_d port map (clk,rst,input,tmp(0));
GEN: for i in 0 to N-2 generate
	bd: bas_d port map (clk,rst,tmp(i),tmp(i+1));
end generate;

end arch_reg_dec;
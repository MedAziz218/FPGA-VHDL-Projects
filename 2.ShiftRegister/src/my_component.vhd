library ieee;
use ieee.std_logic_1164.all;

package my_component is
component bas_d is
	port (
		clk,rst,d : in std_logic;
		q: out std_logic
	);
end component;

component reg_dec is
	generic(
		N: integer:=8
	);
	port (
		clk,rst,input : in std_logic;
		output: out std_logic_vector (N-1 downto 0)
	);
end component;


end package;
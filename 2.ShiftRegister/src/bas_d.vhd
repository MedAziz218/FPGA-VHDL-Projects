library ieee;
use ieee.std_logic_1164.all;

entity bas_d is
	port (
		clk,rst,d : in std_logic;
		q: out std_logic
	);
end entity;

--commentaire

architecture arch_bas_d of bas_d is
begin
	process (clk,rst)
	begin
		if(rst='1') then 
			q<='0';
		else
			if (clk'event and clk='1') then
				q<=d;
			end if;
		end if;
	end process;
end arch_bas_d;
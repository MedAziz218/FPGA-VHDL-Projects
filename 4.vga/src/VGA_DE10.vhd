library ieee;
use ieee.std_logic_1164.all;

entity vga_DE10 is
	port(
		CLOCK_50 :IN std_logic;						--	50 MHz
		reset:IN std_logic;							-- reset key
		SW: IN std_logic_vector (3 downto 0); 	-- switches
		VGA_CLK:OUT std_logic;			--
		VGA_HS: OUT std_logic;						-- VGA H_SYNC
		VGA_VS:OUT std_logic;						-- VGA V_SYNC
		VGA_BLANK:OUT std_logic;					-- VGA BLANK
		VGA_SYNC:OUT std_logic;					 	-- VGA SYNC
		VGA_R: OUT std_logic_vector(3 downto 0);	-- VGA Red[3:0]
		VGA_G: OUT std_logic_vector(3 downto 0);	-- VGA Green[3:0]
		VGA_B: OUT std_logic_vector(3 downto 0)	-- VGA Blue[3:0]
	);
end entity;

architecture vgade2arch of vga_de10 is
component VGA is port(
	--Host Side
	iRed,
	iGreen,
	iBlue : IN std_logic_vector (3 downto 0);
	oRequest : OUT std_logic;
	--VGA Side
	oVGA_R,
	oVGA_G,
	oVGA_B : OUT std_logic_vector (3 downto 0);
	oVGA_H_SYNC,
	oVGA_V_SYNC,
	oVGA_SYNC,
	oVGA_BLANK,
	oVGA_CLOCK : OUT std_logic;
	--Control Signal
	iCLK,
	iRST_N : IN std_logic;
	X,Y : OUT Integer  range 0 to 1023
);
end component;
signal red,blue,green: std_logic_vector (3 downto 0);
signal VGA_CTRL_CLK: std_logic;
signal X,Y : Integer  range 0 to 1023;
begin
-- GENERATE PIXELS
process(SW, X, Y)
begin
    if X >= 0 and X < 80 then           -- Section 1
        red   <= "0000";                -- Red: 0
        green <= "0000";                -- Green: 0
        blue  <= "0000";                -- Blue: 0

    elsif  X < 160 then      -- Section 2
        red   <= "1111";                -- Red: 15
        green <= "0000";                -- Green: 0
        blue  <= "0000";                -- Blue: 0

    elsif X < 240 then     -- Section 3
        red   <= "0000";                -- Red: 0
        green <= "1111";                -- Green: 15
        blue  <= "0000";                -- Blue: 0

    elsif  X < 320 then     -- Section 4
        red   <= "0000";                -- Red: 0
        green <= "0000";                -- Green: 0
        blue  <= "1111";                -- Blue: 15

    elsif  X < 400 then     -- Section 5
        red   <= "1111";                -- Red: 15
        green <= "1111";                -- Green: 15
        blue  <= "0000";                -- Blue: 0

    elsif  X < 480 then     -- Section 6
        red   <= "0000";                -- Red: 0
        green <= "1111";                -- Green: 15
        blue  <= "1111";                -- Blue: 15

    elsif X < 560 then     -- Section 7
        red   <= "1111";                -- Red: 15
        green <= "0000";                -- Green: 0
        blue  <= "1111";                -- Blue: 15

    elsif X <= 639 then    -- Section 8
        red   <= "1111";                -- Red: 15
        green <= "1111";                -- Green: 15
        blue  <= "1111";                -- Blue: 15

    else                                -- Default case
        red   <= "1111";                -- Default to black
        green <= "1111";
        blue  <= "1111";
    end if;
end process;
-- GENERATE CLOCK
process (CLOCK_50,reset)
begin
	if(reset='0')then
		VGA_CTRL_CLK <= '0';   --VGA_CTRL_CLK init
	else
		if(CLOCK_50='1' and CLOCK_50'event) then
			 VGA_CTRL_CLK <= not VGA_CTRL_CLK;  --VGA_CTRL_CLK
		end if;
	end if;
end process;
--VGA_CLK <= VGA_CTRL_CLK;    --VGA_CLK
-- VGA COMPONENT
 VGA1: VGA port map(oRequest=>open,
					iRed=>red,
					iGreen=>green,
					iBlue=>blue,
					oVGA_R=>VGA_R,
					oVGA_G=>VGA_G,
					oVGA_B=>VGA_B,
					oVGA_H_SYNC=>VGA_HS,
					oVGA_V_SYNC=>VGA_VS,
					oVGA_SYNC=>VGA_SYNC,
					oVGA_BLANK=>VGA_BLANK,
					iCLK=>VGA_CTRL_CLK,
					iRST_N=>reset,
					X=>X,
					Y=>Y);
end vgade2arch;
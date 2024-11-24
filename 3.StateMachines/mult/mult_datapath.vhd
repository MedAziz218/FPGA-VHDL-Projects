LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mult_datapath IS
    PORT (
        Clk, calc : IN STD_LOGIC;
        Multiplicand, multiplier : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        oDone : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE bhv OF mult_datapath IS

    SIGNAL smultiplicand, currmultiplier, nextmultiplier : unsigned(3 DOWNTO 0);
    SIGNAL curresult, nextresult : unsigned(7 DOWNTO 0);
    SIGNAL zero_fill : unsigned(7 DOWNTO 0);

BEGIN

    PROCESS (clk, calc)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (calc = '0') THEN
                smultiplicand <= unsigned(multiplicand);
                Currmultiplier <= unsigned(multiplier);
                Curresult <= (OTHERS => '0');
            ELSE
                smultiplicand <= unsigned(multiplicand);
                Currmultiplier <= nextmultiplier;
                Curresult <= nextresult;
            END IF;
        END IF;

    END PROCESS;

    PROCESS (currmultiplier)
    BEGIN
        IF (currmultiplier = 0) THEN
            Nextmultiplier <= currmultiplier;
            Nextresult <= curresult;
            oDone <= '1';
        ELSE
            Nextmultiplier <= currmultiplier - 1;
            Nextresult <= ("0000" & smultiplicand) + curresult;
            oDone <= '0';
        END IF;
    END PROCESS;

    result <= STD_LOGIC_VECTOR(curresult);

END ARCHITECTURE;
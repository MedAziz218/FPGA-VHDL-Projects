LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mult_fsm IS
    PORT (
        clk, reset, startn, done : IN STD_LOGIC;
        calcul, complete : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE bhv OF mult_fsm IS

    TYPE state IS (idle, run, finish);
    SIGNAL currstate, nextstate : state;

BEGIN

    PROCESS (currstate, startn, done)
    BEGIN
        CASE currstate IS
            WHEN idle =>
                IF (startn = '0') THEN
                    Nextstate <= run;
                ELSE
                    Nextstate <= idle;
                END IF;

            WHEN run =>
                IF (done = '1') THEN
                    Nextstate <= finish;
                ELSE
                    Nextstate <= run;
                END IF;

            WHEN finish =>
                Nextstate <= idle;
        END CASE;
    END PROCESS;

    PROCESS (clk, reset)
    BEGIN
        IF (reset = '0') THEN
            currstate <= idle;
        ELSIF (rising_edge(clk)) THEN
            currstate <= nextstate;
        END IF;
    END PROCESS;

    PROCESS (currstate)
    BEGIN
        CASE currstate IS
            WHEN idle =>
                complete <= '0';
                Calcul <= '0';
            WHEN run =>
                complete <= '0';
                Calcul <= '1';
            WHEN finish =>
                complete <= '1';
                Calcul <= '0';
        END CASE;
    END PROCESS;

END ARCHITECTURE;
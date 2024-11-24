LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY gcd IS
    PORT (
        ina, inb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Start, clock, reset : IN STD_LOGIC;
        o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        done : OUT STD_LOGIC
    );
END gcd;

ARCHITECTURE Behavioral OF gcd IS
    TYPE states IS (INIT, READIN, COMPARE, DECA, DECB, FINISH);
    SIGNAL currentstate, nextstate : states;
    SIGNAL a, a_in : unsigned(3 DOWNTO 0);
    SIGNAL b, b_in : unsigned(3 DOWNTO 0);

BEGIN

    PROCESS (clock, reset)
    BEGIN
        IF (reset = '0') THEN
            currentstate <= INIT;
            a <= (OTHERS => '0');
            b <= (OTHERS => '0');
        ELSIF (clock'event AND clock = '1') THEN
            currentstate <= nextstate;
            a <= a_in;
            b <= b_in;
        END IF;
    END PROCESS;
    PROCESS (currentstate, start, a, b)
    BEGIN

        CASE currentstate IS
            WHEN init =>
                IF (start = '0') THEN
                    Nextstate <= init;
                ELSE
                    Nextstate <= readin;
                END IF;

            WHEN readin =>
                Nextstate <= compare;

            WHEN compare =>
                IF (a = b) THEN
                    Nextstate <= finish;
                ELSIF (a > b) THEN
                    Nextstate <= deca;
                ELSE
                    Nextstate <= decb;
                END IF;

            WHEN deca =>
                Nextstate <= compare;

            WHEN decb =>
                Nextstate <= compare;

            WHEN finish =>
                IF (start = '0') THEN
                    Nextstate <= init;
                ELSE
                    Nextstate <= finish;
                END IF;

            WHEN OTHERS =>
                Nextstate <= init;

        END CASE;
    END PROCESS;
    PROCESS (currentstate, ina, a, b)
    BEGIN

        CASE currentstate IS
            WHEN readin =>

                a_in <= unsigned(ina);
            WHEN deca =>
                a_in <= a - b;
            WHEN OTHERS =>
                a_in <= a;
        END CASE;
    END PROCESS;

    PROCESS (currentstate, ina, a, b)
    BEGIN
        CASE currentstate IS
            WHEN readin =>

                b_in <= unsigned(inb);
            WHEN decb =>
                b_in <= b - a;
            WHEN OTHERS =>
                b_in <= b;
        END CASE;
    END PROCESS;

    o <= STD_LOGIC_VECTOR(a);

    PROCESS (currentstate)
    BEGIN
        CASE currentstate IS
            WHEN finish =>
                Done <= '1';
            WHEN OTHERS =>
                Done <= '0';
        END CASE;
    END PROCESS;

END ARCHITECTURE;
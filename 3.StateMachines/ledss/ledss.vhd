LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ledss IS
  GENERIC (
    N : NATURAL := 10
  );
  PORT (
    rst, clk, start : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
  );
END ENTITY;

ARCHITECTURE fsm OF ledss IS

  TYPE states IS (idle, ready, sl, sr);
  SIGNAL cs, ns : states;
  SIGNAL currentled, nextled : unsigned(N - 1 DOWNTO 0);
BEGIN

  PROCESS (rst, clk)
  BEGIN
    IF (rst = '0') THEN
      cs <= idle;
      currentled <= (OTHERS => '0');
    ELSIF (clk'event AND clk = '1') THEN
      cs <= ns;
      currentled <= nextled;
    END IF;
  END PROCESS;

  PROCESS (cs, currentled)
  BEGIN
    CASE cs IS
      WHEN idle =>
        nextled <= (OTHERS => '0');
      WHEN ready =>
        nextled <= "0000000001";
      WHEN sl =>
        nextled <= shift_left(currentled, 1);
      WHEN sr =>
        nextled <= shift_right(currentled, 1);
    END CASE;
  END PROCESS;

  PROCESS (cs, start, currentled)
  BEGIN
    CASE cs IS
      WHEN idle =>
        IF (start = '0') THEN
          ns <= idle;
        ELSE
          ns <= ready;
        END IF;

      WHEN ready =>
        ns <= sl;

      WHEN sl =>
        IF (currentled < 256) THEN
          ns <= sl;
        ELSE
          ns <= sr;
        END IF;

      WHEN sr =>
        IF (currentled > 2) THEN
          ns <= sr;
        ELSE
          ns <= sl;
        END IF;

    END CASE;
  END PROCESS;

  dout <= STD_LOGIC_VECTOR(currentled);
END fsm;
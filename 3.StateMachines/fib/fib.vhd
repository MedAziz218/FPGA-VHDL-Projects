LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fib IS
   PORT (
      clk, reset : IN STD_LOGIC;
      start : IN STD_LOGIC;
      i : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      ready : OUT STD_LOGIC;
      done_tick : OUT STD_LOGIC;
      f : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
   );
END fib;

ARCHITECTURE arch OF fib IS
   TYPE state_type IS (idle, op, done);
   SIGNAL state_reg, state_next : state_type;
   SIGNAL t0_reg, t0_next : unsigned(19 DOWNTO 0);
   SIGNAL t1_reg, t1_next : unsigned(19 DOWNTO 0);
   SIGNAL n_reg, n_next : unsigned(4 DOWNTO 0);

BEGIN
   -- fsmd state and data registers
   PROCESS (clk, reset)
   BEGIN
      IF reset = '0' THEN
         state_reg <= idle;
         t0_reg <= (OTHERS => '0');
         t1_reg <= (OTHERS => '0');
         n_reg <= (OTHERS => '0');
      ELSIF (clk'event AND clk = '1') THEN
         state_reg <= state_next;
         t0_reg <= t0_next;
         t1_reg <= t1_next;
         n_reg <= n_next;
      END IF;

   END PROCESS;

   -- fsmd next-state logic
   PROCESS (state_reg, n_reg, t0_reg, t1_reg, start, i, n_next)
   BEGIN
      ready <= '0';
      done_tick <= '0';
      --state_next <= state_reg;
      --t0_next    <= t0_reg;
      --t1_next    <= t1_reg;
      --n_next     <= n_reg;
      CASE state_reg IS
         WHEN idle =>
            ready <= '1';
            IF start = '1' THEN
               t0_next <= (OTHERS => '0');
               t1_next <= (0 => '1', OTHERS => '0');
               n_next <= unsigned(i);
               state_next <= op;
            END IF;
         WHEN op =>
            IF n_reg = 0 THEN
               t1_next <= (OTHERS => '0');
               state_next <= done;
            ELSIF n_reg = 1 THEN
               state_next <= done;
            ELSE
               t1_next <= t1_reg + t0_reg;
               t0_next <= t1_reg;
               n_next <= n_reg - 1;
            END IF;
         WHEN done =>
            done_tick <= '1';
            state_next <= idle;
      END CASE;
   END PROCESS;
   -- output
   f <= STD_LOGIC_VECTOR(t1_reg);

END arch;
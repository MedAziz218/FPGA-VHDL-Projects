LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fib_tb IS
END ENTITY;

ARCHITECTURE tb OF fib_tb IS

  COMPONENT fib IS
    PORT (
      clk, reset : IN STD_LOGIC;
      start : IN STD_LOGIC;
      i : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
      ready : OUT STD_LOGIC;
      done_tick : OUT STD_LOGIC;
      f : OUT STD_LOGIC_VECTOR(19 DOWNTO 0)
    );
  END COMPONENT;
  SIGNAL rst_tb : STD_LOGIC;
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL start_tb : STD_LOGIC := '1';

  SIGNAL i_tb : STD_LOGIC_VECTOR(4 DOWNTO 0) := "00110";
  SIGNAL ready_tb : STD_LOGIC;
  SIGNAL done_tb : STD_LOGIC;
  SIGNAL f_tb : STD_LOGIC_VECTOR(19 DOWNTO 0);

  CONSTANT hp : TIME := 50 ns;
BEGIN

  DUT : fib
  PORT MAP(
    clk => clk_tb,
    reset => rst_tb,
    start => start_tb,
    i => i_tb,
    ready => ready_tb,
    done_tick => done_tb,
    f => f_tb
  );

  clk_tb <= NOT clk_tb AFTER hp;
  rst_tb <= '0', '1' AFTER 2 * hp;

END tb;
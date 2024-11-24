LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ledss_tb IS
END ENTITY;

ARCHITECTURE tb OF ledss_tb IS

  COMPONENT ledss IS
    GENERIC (
      N : NATURAL := 10
    );
    PORT (
      rst, clk, start : IN STD_LOGIC;
      dout : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
  END COMPONENT;

  CONSTANT N : NATURAL := 10;
  SIGNAL rst_tb : STD_LOGIC;
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL start_tb : STD_LOGIC := '1';
  SIGNAL dout_tb : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);

  CONSTANT hp : TIME := 50 ns;
BEGIN

  DUT : ledss
  GENERIC MAP(
    10) PORT MAP(
    rst => rst_tb,
    clk => clk_tb,
    start => start_tb,
    dout => dout_tb
  );

  clk_tb <= NOT clk_tb AFTER hp;
  rst_tb <= '0', '1' AFTER 2 * hp;

END tb;
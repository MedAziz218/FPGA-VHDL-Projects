LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mult_tb IS
END ENTITY;

ARCHITECTURE tb OF mult_tb IS

  COMPONENT mult_fsmd IS
    PORT (
      Clk, rstn, startn : IN STD_LOGIC;
      Multiplicand, multiplier : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      Result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      Ocomplete : OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL rst_tb : STD_LOGIC;
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL start_tb : STD_LOGIC := '0';

  SIGNAL mltc_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  SIGNAL mlti_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  SIGNAL complete_tb : STD_LOGIC;
  SIGNAL r_tb : STD_LOGIC_VECTOR(7 DOWNTO 0);

  CONSTANT hp : TIME := 50 ns;
BEGIN

  DUT : mult_fsmd
  PORT MAP(
    clk => clk_tb,
    rstn => rst_tb,
    startn => start_tb,
    multiplicand => mltc_tb,
    multiplier => mlti_tb,
    result => r_tb,
    ocomplete => complete_tb
  );

  clk_tb <= NOT clk_tb AFTER hp;
  rst_tb <= '0', '1' AFTER 2 * hp;

END tb;
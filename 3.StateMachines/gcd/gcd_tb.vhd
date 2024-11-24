LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY gcd_tb IS
END ENTITY;

ARCHITECTURE tb OF gcd_tb IS

  COMPONENT gcd IS
    PORT (
      ina, inb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      Start, clock, reset : IN STD_LOGIC;
      o : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      done : OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL rst_tb : STD_LOGIC;
  SIGNAL clk_tb : STD_LOGIC := '0';
  SIGNAL start_tb : STD_LOGIC := '1';
  --signal ina_tb : unsigned(3 downto 0):="1110";
  --signal inb_tb : unsigned(3 downto 0):="0110";
  SIGNAL ina_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
  SIGNAL inb_tb : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  SIGNAL dout_tb : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL done_tb : STD_LOGIC;

  CONSTANT hp : TIME := 50 ns;
BEGIN

  DUT : gcd
  PORT MAP(
    --ina => std_logic_vector(ina_tb),
    --inb => std_logic_vector(inb_tb),
    ina => ina_tb,
    inb => inb_tb,
    reset => rst_tb,
    clock => clk_tb,
    start => start_tb,
    o => dout_tb,
    done => done_tb
  );

  clk_tb <= NOT clk_tb AFTER hp;
  rst_tb <= '0', '1' AFTER 2 * hp;

END tb;
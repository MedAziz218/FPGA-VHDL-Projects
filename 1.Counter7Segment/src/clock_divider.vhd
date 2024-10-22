library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity clock_divider is
  generic (
    DIV_FACTOR : integer := 50 -- Default value, can be overridden
  );
  port (
    clock_in  : in  STD_LOGIC;
    reset_n   : in  STD_LOGIC;
    clock_out : out STD_LOGIC
  );
end entity;

architecture Behavioral of clock_divider is

  signal count : integer   := 1;
  signal tmp   : std_logic := '0';

begin
  process (clock_in, reset_n)
  begin
    if (reset_n = '0') then
      count <= 1;
      tmp <= '0';
    elsif (clock_in'event and clock_in = '1') then
      count <= count + 1;
      if (count = DIV_FACTOR/2) then
        tmp <= not tmp;
        count <= 1;
      end if;
    end if;
    clock_out <= tmp;
  end process;
end architecture;


-- [assuming clock_in is 50MHz]
-- DIV_FACTOR|-->Output Frequency
-- 2 |--> 25MHz
-- 50 |-->   1MHz
-- 100 |--> 500KHz
-- 2000 |-->  25KHz
-- 50000 |-->   1KHz
-- 1000000 |-->  50Hz
-- 10000000 |-->  5Hz
-- 50000000 |-->  1Hz


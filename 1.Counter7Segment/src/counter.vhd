library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.NUMERIC_STD.all;

entity counter is
  port (
    clock_in  : in  STD_LOGIC;                   -- clock
    reset_n  : in  STD_LOGIC;                   -- Reset
    flag : out STD_LOGIC;                   -- indicates when couter == 9
    Q    : out STD_LOGIC_VECTOR(3 downto 0) -- output ( 0 to 9)
  );
end entity;

architecture Behavioral of counter is
  signal count : unsigned(3 downto 0) := (others => '0'); -- internal counter signal
begin

  process (clock_in, reset_n)
  begin
    if reset_n = '0' then
      -- Reset the counter to 0
      count <= (others => '0');
    elsif rising_edge(clock_in) then
      if count = "1001" then -- when the counter reaches 9
        count <= (others => '0'); -- reset to 0
      else
        count <= count + 1; -- increment the counter
      end if;
    end if;
  end process;

  -- Output the current count as a std_logic_vector
  Q <= std_logic_vector(count);

  -- Set flag when the counter reaches 9
  flag <= '1' when count = "1001" else '0';

end architecture;

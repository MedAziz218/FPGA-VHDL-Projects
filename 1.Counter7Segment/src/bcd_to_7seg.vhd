library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_UNSIGNED.all;

entity bcd_to_7seg is
  port (
    bcd_in    : in  std_logic_vector(3 downto 0); -- 4-bit BCD input
    seg_out_n : out std_logic_vector(7 downto 0)  -- 8-bit output for 7-segment (7 seg + decimal point)
  );
end entity;

architecture Behavioral of bcd_to_7seg is
begin
  process (bcd_in)
  begin
    case bcd_in is
      -- 7-segment output (active low) for each digit 0-9
      when "0000" => seg_out_n <= "11000000"; -- 0
      when "0001" => seg_out_n <= "11111001"; -- 1
      when "0010" => seg_out_n <= "10100100"; -- 2
      when "0011" => seg_out_n <= "10110000"; -- 3
      when "0100" => seg_out_n <= "10011001"; -- 4
      when "0101" => seg_out_n <= "10010010"; -- 5
      when "0110" => seg_out_n <= "10000010"; -- 6
      when "0111" => seg_out_n <= "11111000"; -- 7
      when "1000" => seg_out_n <= "10000000"; -- 8
      when "1001" => seg_out_n <= "10010000"; -- 9
      when others => seg_out_n <= "11111111"; -- blank or invalid input
    end case;
  end process;
end architecture;

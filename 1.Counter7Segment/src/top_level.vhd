library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity top_level is
  generic (
    DIV_FACTOR : integer := 50 -- 50000000 for 1Hz (see clock_divider.vhd)
  );
  port (
    -- ADC_CLK_10      : in    std_logic;
    MAX10_CLK1_50 : in  std_logic;
    -- MAX10_CLK2_50   : in    std_logic;
    -- DRAM_ADDR       : out   std_logic_vector(12 downto 0);
    -- DRAM_BA         : out   std_logic_vector(1 downto 0);
    -- DRAM_CAS_N      : out   std_logic;
    -- DRAM_CKE        : out   std_logic;
    -- DRAM_CLK        : out   std_logic;
    -- DRAM_CS_N       : out   std_logic;
    -- DRAM_DQ         : inout std_logic_vector(15 downto 0);
    -- DRAM_LDQM       : out   std_logic;
    -- DRAM_RAS_N      : out   std_logic;
    -- DRAM_UDQM       : out   std_logic;
    -- DRAM_WE_N       : out   std_logic;
    HEX0          : out std_logic_vector(7 downto 0);
    -- HEX1            : out   std_logic_vector(7 downto 0);
    -- HEX2            : out   std_logic_vector(7 downto 0);
    -- HEX3            : out   std_logic_vector(7 downto 0);
    -- HEX4            : out   std_logic_vector(7 downto 0);
    -- HEX5            : out   std_logic_vector(7 downto 0);
    KEY           : in  std_logic_vector(1 downto 0);
    LEDR          : out std_logic_vector(9 downto 0)
      -- SW              : in    std_logic_vector(9 downto 0);
      -- VGA_B           : out   std_logic_vector(3 downto 0);
      -- VGA_G           : out   std_logic_vector(3 downto 0);
      -- VGA_HS          : out   std_logic;
      -- VGA_R           : out   std_logic_vector(3 downto 0);
      -- VGA_VS          : out   std_logic;
      -- GSENSOR_CS_N    : out   std_logic;
      -- GSENSOR_INT     : in    std_logic_vector(1 downto 0);
      -- GSENSOR_SCLK    : out   std_logic;
      -- GSENSOR_SDI     : inout std_logic;
      -- GSENSOR_SDO     : inout std_logic;
      -- ARDUINO_IO      : inout std_logic_vector(15 downto 0);
      -- ARDUINO_RESET_N : inout std_logic := '0'
  );
end entity;

architecture Behavioral of top_level is

  --=======================================================
  --  Signals declarations
  --=======================================================
  -- input
  signal clock_50_in, reset_n : std_logic;
  --------------
  signal divided_clock_out : std_logic;
  signal counter_bcd_out   : std_logic_vector(3 downto 0);
  -- output
  signal flag      : std_logic;
  signal seg_out_n : std_logic_vector(7 downto 0) := (others => '0');

  --=======================================================

begin
  uut_clock_divider: entity work.clock_divider
    generic map (
      DIV_FACTOR => DIV_FACTOR
    )
    port map (
      clock_in  => clock_50_in,
      reset_n   => reset_n,
      clock_out => divided_clock_out
    );
  uut_counter: entity work.counter

    port map (
      clock_in => divided_clock_out,
      reset_n  => reset_n,
      flag     => flag,
      Q        => counter_bcd_out
    );
  uut_bcd_to_7: entity work.bcd_to_7seg
    port map (
      bcd_in    => counter_bcd_out,
      seg_out_n => seg_out_n
    );
  --=======================================================
  --  Signal Mapping for the bord
  --=======================================================
  -- input
  clock_50_in <= MAX10_CLK1_50;
  reset_n     <= KEY(0);
  -- output
  LEDR(9) <= flag;
  HEX0    <= seg_out_n;

end architecture;

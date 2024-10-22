-- ****************************************************************************
-- Testbench for FPGA 7-Segment Counter
--
-- This file contains three test benches for simulating in ModelSim the components
-- of the FPGA 7-segment counter on the DE10-Lite board:
--
-- 1. tb_toplevel: Simulates the complete design for the DE10-Lite board.
-- 2. tb_counter: Tests the counter and BCD to 7-segment components.
-- 3. tb_clock_divider: Verifies the clock divider functionality.
--
-- Simulation Tool: ModelSim
-- ****************************************************************************

library IEEE;
  use IEEE.STD_LOGIC_1164.all;
library work;
  use work.top_level;
  use work.clock_divider;
  use work.counter;
  use work.bcd_to_7seg;

entity tb_DE10_LITE is
  -- Testbench has no ports
end entity;
-- *================{TEST BENCH 1}=========================*

architecture tb_top_level of tb_DE10_LITE is

  --=======================================================
  --  Simulation Signals
  --=======================================================
  signal sim_clk_50 : std_logic := '0';
  signal sim_rst_N  : std_logic := '1'; -- reset signal active low

  signal KEY_N  : std_logic_vector(1 downto 0) := (others => '1'); -- Both keys not pressed
  signal LEDR   : std_logic_vector(9 downto 0) := (others => '0');
  signal HEX0_N : std_logic_vector(7 downto 0) := (others => '1');

  --=======================================================

begin

  -- Instantiate the Unit Under Test (UUT)
  uut: entity work.top_level
    generic map (
      DIV_FACTOR => 4 --50000000 for 1Hz
    )
    port map (
      -- ADC_CLK_10      ,
      MAX10_CLK1_50 => sim_clk_50,
      -- MAX10_CLK2_50   ,
      -- DRAM_ADDR       ,
      -- DRAM_BA         ,
      -- DRAM_CAS_N      ,
      -- DRAM_CKE        ,
      -- DRAM_CLK        ,
      -- DRAM_CS_N       ,
      -- DRAM_DQ         ,
      -- DRAM_LDQM       ,
      -- DRAM_RAS_N      ,
      -- DRAM_UDQM       ,
      -- DRAM_WE_N       ,
      HEX0          => HEX0_N,
      -- HEX1            ,
      -- HEX2            ,
      -- HEX3            ,
      -- HEX4            ,
      -- HEX5            ,
      KEY           => KEY_N,
      LEDR          => LEDR
        -- SW             ,
        -- VGA_B          ,
        -- VGA_G          ,
        -- VGA_HS          ,
        -- VGA_R          ,
        -- VGA_VS          ,
        -- GSENSOR_CS_N    ,
        -- GSENSOR_INT    ,
        -- GSENSOR_SCLK    ,
        -- GSENSOR_SDI     ,
        -- GSENSOR_SDO     ,
        -- ARDUINO_IO      ,
        -- ARDUINO_RESET_N
    );

  --=======================================================
  --  Simulation Scenario (define inputs behaviour)
  --=======================================================
  sim_clk_50 <= not sim_clk_50 after 10 ns;
  sim_rst_N  <= '0' after 50 ns, '1' after 90 ns;
  KEY_N(0)   <= sim_rst_N;
  --=======================================================
end architecture;

-- *================{TEST BENCH 2}=========================*

architecture tb_clock_divider of tb_DE10_LITE is

  --=======================================================
  --  Simulation Signals
  --=======================================================
  signal clock_in  : std_logic := '0';
  signal rst       : std_logic := '1'; -- reset signal active low
  signal clock_out : std_logic;
  --=======================================================

begin
  uut: entity work.clock_divider
    generic map (
      DIV_FACTOR => 10
    )
    port map (
      clock_in  => clock_in,
      reset_n   => rst,
      clock_out => clock_out
    );
  --=======================================================
  --  Simulation Scenario (define inputs behaviour)
  --=======================================================
  clock_in <= not clock_in after 10 ns;
  rst      <= '0' after 55 ns, '1' after 125 ns;
  --=======================================================
end architecture;

-- *================{TEST BENCH 3}=========================*

architecture tb_counter of tb_DE10_LITE is

  --=======================================================
  --  Simulation Signals
  --=======================================================
  signal clock_in : std_logic := '0';
  signal rst      : std_logic := '1'; -- reset signal active low
  signal flag     : std_logic;
  signal Q        : std_logic_vector(3 downto 0);
  --------------
  signal seg_out_n : std_logic_vector(7 downto 0) := (others => '0');

  --=======================================================

begin
  uut_counter: entity work.counter

    port map (
      clock_in => clock_in,
      reset_n  => rst,
      flag     => flag,
      Q        => Q
    );
  uut_bcd_to_7: entity work.bcd_to_7seg
    port map (
      bcd_in    => Q,
      seg_out_n => seg_out_n
    );

  --=======================================================
  --  Simulation Scenario (define inputs behaviour)
  --=======================================================
  clock_in <= not clock_in after 10 ns;
  rst      <= '0' after 55 ns, '1' after 125 ns;
  --=======================================================
end architecture;

-- *================{TEST BENCH 4}=========================*

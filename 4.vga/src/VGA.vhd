library ieee;
  use ieee.std_logic_1164.all;

entity VGA is
  port (
    --Host Side
    iRed, iGreen, iBlue                                         : in  std_logic_vector(3 downto 0);
    oRequest                                                    : out std_logic;
    --VGA Side
    oVGA_R, oVGA_G, oVGA_B                                      : out std_logic_vector(3 downto 0);
    oVGA_H_SYNC, oVGA_V_SYNC, oVGA_SYNC, oVGA_BLANK, oVGA_CLOCK : out std_logic;
    --Control Signal
    iCLK, iRST_N                                                : in  std_logic;
    X, Y                                                        : out Integer range 0 to 1023
  );
end entity;

architecture vgaarch of vga is
  --Horizontal parameter(Pixel)  
  constant H_SYNC_CYC   : integer := 96;
  constant H_SYNC_BACK  : integer := 48;
  constant H_SYNC_ACT   : integer := 640;
  constant H_SYNC_FRONT : integer := 16;
  constant H_SYNC_TOTAL : integer := 800;
  --Virtical parameter (Line) 
  constant V_SYNC_CYC   : integer := 2;
  constant V_SYNC_BACK  : integer := 32;
  constant V_SYNC_ACT   : integer := 480;
  constant V_SYNC_FRONT : integer := 11;
  constant V_SYNC_TOTAL : integer := 525;
  --Start Offset 
  constant X_START : integer := H_SYNC_CYC + H_SYNC_BACK;
  constant Y_START : integer := V_SYNC_CYC + V_SYNC_BACK;

  signal H_Cont, V_Cont               : integer range 0 to 1023;
  signal oVGA_H_SYNC_s, oVGA_V_SYNC_s : std_logic;

begin
  --RGB GENERATION 
  oVGA_R <= iRed when (H_Cont >= X_START and H_Cont < X_START + H_SYNC_ACT and 
							V_Cont >= Y_START and V_Cont < Y_START + V_SYNC_ACT) else
                              (others => '0');
  oVGA_G <= iGreen when (H_Cont >= X_START and H_Cont < X_START + H_SYNC_ACT and 
							V_Cont >= Y_START and V_Cont < Y_START + V_SYNC_ACT) else
										(others => '0');
  oVGA_B <= iBlue when (H_Cont >= X_START and H_Cont < X_START + H_SYNC_ACT and 
								V_Cont >= Y_START and V_Cont < Y_START + V_SYNC_ACT) else
										(others => '0');

  --	Pixel LUT Address Generator
  process (iCLK)
  begin
    if (iCLK = '1') then
      if (iRST_N = '0') then
        oRequest <= '0';
      else
        if (H_Cont >= X_START - 1 and H_Cont < X_START + H_SYNC_ACT - 1 and
             V_Cont >= Y_START and V_Cont < Y_START + V_SYNC_ACT) then
          oRequest <= '1';
        else
          oRequest <= '0';
        end if;
      end if;
    end if;
  end process;

  --	H_Sync Generator, Ref. 25.175 MHz Clock
  process (iCLK)
  begin
    if (iCLK = '1') then
      if (iRST_N = '0') then
        H_Cont <= 0; --H_Cont		
        oVGA_H_SYNC_s <= '0'; --oVGA_H_SYNC_s	
      else
        --H_Sync Counter
        if (H_Cont < H_SYNC_TOTAL) then
          H_Cont <= H_Cont + 1; --H_Cont	
        else
          H_Cont <= 0; --H_Cont	
        end if;
        --	H_Sync Generator
        if (H_Cont < H_SYNC_CYC) then
          oVGA_H_SYNC_s <= '0'; --oVGA_H_SYNC_s	
        else
          oVGA_H_SYNC_s <= '1'; --oVGA_H_SYNC_s
        end if;
      end if;
    end if;
  end process;

  --	V_Sync Generator, Ref. H_Sync
  process (iCLK)
  begin
    if (iCLK = '1') then
      if (iRST_N = '0') then
        V_Cont <= 0; --V_Cont		
        oVGA_V_SYNC_s <= '0'; --oVGA_V_SYNC_s	
      else
        --	When H_Sync Re-start
        if (H_Cont = 0) then
          --	V_Sync Counter
          if (V_Cont < V_SYNC_TOTAL) then
            V_Cont <= V_Cont + 1; --V_Cont	
          else
            V_Cont <= 0; --V_Cont
          end if;
          --	V_Sync Generator
          if (V_Cont < V_SYNC_CYC) then
            oVGA_V_SYNC_s <= '0'; --oVGA_V_SYNC_s
          else
            oVGA_V_SYNC_s <= '1'; --oVGA_V_SYNC_s	
          end if;
        end if;
      end if;
    end if;
  end process;
  oVGA_SYNC <= oVGA_H_SYNC_s and oVGA_V_SYNC_s; -- oVGA_SYNC
  oVGA_V_SYNC <= oVGA_V_SYNC_s; -- oVGA_V_SYNC
  oVGA_H_SYNC <= oVGA_H_SYNC_s; -- oVGA_H_SYNC
  oVGA_BLANK <= '1'; -- oVGA_BLANK 
  oVGA_CLOCK <= iCLK; -- oVGA_CLOCK
  X <= H_Cont - X_START when (H_Cont > X_START and H_Cont < X_START + H_SYNC_ACT) else 0; -- X
  Y <= V_Cont - Y_START when (V_Cont > Y_START and V_Cont < Y_START + V_SYNC_ACT) else 0; -- Y
end architecture;



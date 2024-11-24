LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mult_fsmd IS
    PORT (
        Clk, rstn, startn : IN STD_LOGIC;
        Multiplicand, multiplier : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        Ocomplete : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE bhv OF mult_fsmd IS

    SIGNAL scalc, sdone, scomplete : STD_LOGIC;
    SIGNAL sResult : STD_LOGIC_VECTOR(7 DOWNTO 0);

    COMPONENT mult_fsm IS
        PORT (
            clk, reset, startn, done : IN STD_LOGIC;
            calcul, complete : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT mult_datapath IS
        PORT (
            Clk, calc : IN STD_LOGIC;
            Multiplicand, multiplier : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            oDone : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    uut : mult_fsm
    PORT MAP(
        clk => clk,
        reset => rstn,
        startn => startn,
        Done => sdone,
        calcul => scalc,
        Complete => scomplete
    );

    dut : mult_datapath
    PORT MAP(
        clk => clk,
        calc => scalc,
        multiplicand => multiplicand,
        multiplier => multiplier,
        odone => sdone,
        result => result
    );
    oComplete <= scomplete;
END ARCHITECTURE;
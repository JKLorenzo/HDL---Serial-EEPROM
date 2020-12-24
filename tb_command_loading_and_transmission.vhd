LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_command_loading_and_transmission IS
END;

ARCHITECTURE tb_behavior OF tb_command_loading_and_transmission IS
    CONSTANT period : TIME := 20 ns;
    CONSTANT pulses : INTEGER := 17;
    CONSTANT size : INTEGER := 15;

    COMPONENT clock IS
        GENERIC (
            period : TIME;
            pulses : INTEGER
        );
        PORT (
            clk : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT piso IS
        GENERIC (
            size : INTEGER
        );
        PORT (
            si : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
            sh_ld : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            q : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT sipo IS
        GENERIC (
            size : INTEGER
        );
        PORT (
            si : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            q : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL d : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
    SIGNAL si : STD_LOGIC;
    SIGNAL sh_ld : STD_LOGIC;
    SIGNAL q_serial : STD_LOGIC;
    SIGNAL q : STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
BEGIN
    clock_module : clock GENERIC MAP(period, pulses) PORT MAP(clk);
    piso_module : piso GENERIC MAP(size) PORT MAP(si, d, sh_ld, clk, q_serial);
    sipo_module : sipo GENERIC MAP(size) PORT MAP(q_serial, clk, q);

    PROCESS
    BEGIN
        si <= '0';
        -- write operation: 101
        -- address: 1011
        -- data in: 11000011 
        d <= "110000111011101"; -- data & address & operation
        sh_ld <= '0'; -- load
        WAIT FOR period;

        sh_ld <= '1'; -- shift
        WAIT;
    END PROCESS;
END;
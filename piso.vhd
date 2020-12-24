LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY piso IS
    GENERIC (
        size : INTEGER := 15
    );
    PORT (
        si : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(size - 1 DOWNTO 0);
        sh_ld : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        q : OUT STD_LOGIC
    );
END;

ARCHITECTURE behavior OF piso IS
    SIGNAL registers : STD_LOGIC_VECTOR(size - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk)
    BEGIN
        IF RISING_EDGE(clk) THEN
            IF sh_ld = '0' THEN
                -- load
                registers <= d;
            ELSE
                -- shift
                registers <= si & registers(size - 1 DOWNTO 1);
            END IF;
        END IF;
    END PROCESS;
    q <= '0' WHEN sh_ld = '0' ELSE
        registers(0);
END;
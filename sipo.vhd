LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY sipo IS
    GENERIC (
        size : INTEGER
    );
    PORT (
        si : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        q : OUT STD_LOGIC_VECTOR(size - 1 DOWNTO 0)
    );
END;

ARCHITECTURE behavior OF sipo IS
    SIGNAL registers : STD_LOGIC_VECTOR(size - 1 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (si, clk)
    BEGIN
        IF RISING_EDGE(clk) THEN
            registers <= si & registers(size - 1 DOWNTO 1);
        END IF;
    END PROCESS;
    q <= registers;
END;
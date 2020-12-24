LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY clock IS
    GENERIC (
        period : TIME;
        pulses : INTEGER
    );
    PORT (
        clk : OUT STD_LOGIC
    );
END;

ARCHITECTURE behavior OF clock IS
BEGIN
    PROCESS
    BEGIN
        FOR counter IN 1 TO pulses LOOP
            clk <= '0';
            WAIT FOR period / 2;
            clk <= '1';
            WAIT FOR period / 2;
        END LOOP;
        WAIT;
    END PROCESS;
END;
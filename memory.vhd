LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.MATH_REAL.ALL;

ENTITY memory IS
    GENERIC (
        data_size : INTEGER;
        address_size : INTEGER
    );
    PORT (
        data_in : IN STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
        address : IN STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
        cs_bar : IN STD_LOGIC;
        rd_bar : IN STD_LOGIC;
        wr_bar : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0)
    );
END;

ARCHITECTURE behavior OF memory IS
    -- 2 ** address_size - 1 === 2^n - 1
    TYPE mem_type IS ARRAY (0 TO 2 ** address_size - 1) OF STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
    SIGNAL mem : mem_type;
BEGIN
    PROCESS (data_in, address, cs_bar, rd_bar, wr_bar)
    BEGIN
        IF cs_bar = '0' THEN
            IF rd_bar = '0' THEN
                data_out <= mem(CONV_INTEGER(UNSIGNED(address)));
            ELSIF wr_bar = '0' THEN
                mem(CONV_INTEGER(UNSIGNED(address))) <= data_in;
                data_out <= (OTHERS => 'Z');
            END IF;
        END IF;
    END PROCESS;
END;
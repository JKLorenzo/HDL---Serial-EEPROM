LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_memory IS
END;

ARCHITECTURE tb_behavior OF tb_memory IS
    CONSTANT data_size : INTEGER := 8;
    CONSTANT address_size : INTEGER := 4;

    COMPONENT memory IS
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
    END COMPONENT;

    SIGNAL data_in : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
    SIGNAL cs_bar : STD_LOGIC;
    SIGNAL rd_bar : STD_LOGIC;
    SIGNAL wr_bar : STD_LOGIC;
    SIGNAL data_out : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
BEGIN
    memory_module : memory GENERIC MAP(data_size, address_size) PORT MAP(data_in, address, cs_bar, rd_bar, wr_bar, data_out);

    PROCESS
    BEGIN
        address <= "1011";
        data_in <= "11000011";
        cs_bar <= '1';
        rd_bar <= '1';
        wr_bar <= '1';

        -- read
        cs_bar <= '0';
        rd_bar <= '0';
        WAIT FOR 20 ns;

        -- reset
        cs_bar <= '1';
        rd_bar <= '1';
        wr_bar <= '1';

        -- write
        cs_bar <= '0';
        wr_bar <= '0';
        WAIT FOR 20 ns;

        -- reset
        cs_bar <= '1';
        rd_bar <= '1';
        wr_bar <= '1';

        -- read
        cs_bar <= '0';
        rd_bar <= '0';
        WAIT FOR 20 ns;

        WAIT;
    END PROCESS;
END;
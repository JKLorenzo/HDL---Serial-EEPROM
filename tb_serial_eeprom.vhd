LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_serial_eeprom IS
END;

ARCHITECTURE tb_behavior OF tb_serial_eeprom IS
    CONSTANT period : TIME := 20 ns;
    CONSTANT pulses : INTEGER := 36;
    CONSTANT data_size : INTEGER := 8;
    CONSTANT address_size : INTEGER := 4;
    CONSTANT operation_size : INTEGER := 3;

    COMPONENT clock IS
        GENERIC (
            period : TIME;
            pulses : INTEGER
        );
        PORT (
            clk : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT serial_eeprom IS
        GENERIC (
            data_size : INTEGER;
            address_size : INTEGER;
            operation_size : INTEGER
        );
        PORT (
            si : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(data_size + address_size + operation_size - 1 DOWNTO 0);
            sh_ld : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            data : OUT STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
            address : OUT STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
            operation : OUT STD_LOGIC_VECTOR(operation_size - 1 DOWNTO 0);
            cs_bar : OUT STD_LOGIC;
            rd_bar : OUT STD_LOGIC;
            wr_bar : OUT STD_LOGIC;
            data_out : OUT STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL d : STD_LOGIC_VECTOR(data_size + address_size + operation_size - 1 DOWNTO 0);
    SIGNAL si : STD_LOGIC;
    SIGNAL sh_ld : STD_LOGIC;
    SIGNAL data : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
    SIGNAL operation : STD_LOGIC_VECTOR(operation_size - 1 DOWNTO 0);
    SIGNAL cs_bar : STD_LOGIC;
    SIGNAL rd_bar : STD_LOGIC;
    SIGNAL wr_bar : STD_LOGIC;
    SIGNAL data_out : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
BEGIN
    clock_module : clock GENERIC MAP(period, pulses) PORT MAP(clk);
    serial_eeprom_module : serial_eeprom GENERIC MAP(data_size, address_size, operation_size) PORT MAP(si, d, sh_ld, clk, data, address, operation, cs_bar, rd_bar, wr_bar, data_out);

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
        WAIT FOR 310 ns; -- wait to complete the operation

        -- read operation: 001
        -- address: 1011
        -- data in: 11000011 (ignored since it is a read operation)
        d <= "110000111011001"; -- data & address & operation
        sh_ld <= '0'; -- load
        WAIT FOR 30 ns;

        sh_ld <= '1'; -- shift
        WAIT FOR 310 ns; -- wait to complete the operation

        d <= "110000111011101";
        WAIT;
    END PROCESS;
END;
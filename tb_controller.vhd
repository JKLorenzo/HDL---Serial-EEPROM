LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_controller IS
END;

ARCHITECTURE tb_behavior OF tb_controller IS
    CONSTANT period : TIME := 20 ns;
    CONSTANT pulses : INTEGER := 36;
    CONSTANT data_size : INTEGER := 8;
    CONSTANT address_size : INTEGER := 4;
    CONSTANT command_size : INTEGER := 15;
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

    COMPONENT controller IS
        GENERIC (
            data_size : INTEGER := 8;
            address_size : INTEGER := 4;
            command_size : INTEGER := 15;
            operation_size : INTEGER := 3
        );
        PORT (
            command : IN STD_LOGIC_VECTOR(command_size - 1 DOWNTO 0);
            clk : IN STD_LOGIC;
            data : OUT STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
            address : OUT STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
            operation : OUT STD_LOGIC_VECTOR(operation_size - 1 DOWNTO 0);
            cs_bar : OUT STD_LOGIC;
            rd_bar : OUT STD_LOGIC;
            wr_bar : OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC;
    SIGNAL command : STD_LOGIC_VECTOR(command_size - 1 DOWNTO 0);
    SIGNAL data : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
    SIGNAL address : STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
    SIGNAL operation : STD_LOGIC_VECTOR(operation_size - 1 DOWNTO 0);
    SIGNAL cs_bar : STD_LOGIC;
    SIGNAL rd_bar : STD_LOGIC;
    SIGNAL wr_bar : STD_LOGIC;
BEGIN
    clock_module : clock GENERIC MAP(period, pulses) PORT MAP(clk);
    controller_module : controller GENERIC MAP(data_size, address_size, command_size, operation_size) PORT MAP(command, clk, data, address, operation, cs_bar, rd_bar, wr_bar);

    PROCESS
    BEGIN
        -- write operation: 101
        -- address: 1011
        -- data in: 11000011 
        command <= "110000111011101"; -- data & address & operation
        WAIT FOR 330 ns; -- wait to complete the operation

        -- read operation: 001
        -- address: 1011
        -- data in: 11000011 (ignored since it is a read operation)
        command <= "110000111011001"; -- data & address & operation
        WAIT FOR 340 ns; -- wait to complete the operation

        command <= "110000111011101";
        WAIT;
    END PROCESS;
END;
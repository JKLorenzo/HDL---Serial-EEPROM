LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY serial_eeprom IS
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
END;

ARCHITECTURE behavior OF serial_eeprom IS
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

    COMPONENT controller IS
        GENERIC (
            data_size : INTEGER;
            address_size : INTEGER;
            command_size : INTEGER;
            operation_size : INTEGER
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

    SIGNAL piso_to_sipo : STD_LOGIC;
    SIGNAL sipo_to_controller : STD_LOGIC_VECTOR(data_size + address_size + operation_size - 1 DOWNTO 0);

    SIGNAL temp_data : STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0);
    SIGNAL temp_address : STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0);
    SIGNAL temp_cs_bar : STD_LOGIC;
    SIGNAL temp_rd_bar : STD_LOGIC;
    SIGNAL temp_wr_bar : STD_LOGIC;
BEGIN
    piso_module : piso GENERIC MAP(data_size + address_size + operation_size) PORT MAP(si, d, sh_ld, clk, piso_to_sipo);
    sipo_module : sipo GENERIC MAP(data_size + address_size + operation_size) PORT MAP(piso_to_sipo, clk, sipo_to_controller);
    controller_module : controller GENERIC MAP(data_size, address_size, data_size + address_size + operation_size, operation_size) PORT MAP(sipo_to_controller, clk, temp_data, temp_address, operation, temp_cs_bar, temp_rd_bar, temp_wr_bar);
    memory_module : memory GENERIC MAP(data_size, address_size) PORT MAP(temp_data, temp_address, temp_cs_bar, temp_rd_bar, temp_wr_bar, data_out);

    data <= temp_data;
    address <= temp_address;
    cs_bar <= temp_cs_bar;
    rd_bar <= temp_rd_bar;
    wr_bar <= temp_wr_bar;
END;
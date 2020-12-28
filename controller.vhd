LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY controller IS
    GENERIC (
        data_size : INTEGER;
        address_size : INTEGER;
        command_size : INTEGER;
        operation_size : INTEGER
    );
    PORT (
        command : IN STD_LOGIC_VECTOR(command_size - 1 DOWNTO 0);
        clk : IN STD_LOGIC;
        data : OUT STD_LOGIC_VECTOR(data_size - 1 DOWNTO 0) := (OTHERS => '0');
        address : OUT STD_LOGIC_VECTOR(address_size - 1 DOWNTO 0) := (OTHERS => '0');
        operation : OUT STD_LOGIC_VECTOR(operation_size - 1 DOWNTO 0) := (OTHERS => '0');
        cs_bar : OUT STD_LOGIC := '1';
        rd_bar : OUT STD_LOGIC := '1';
        wr_bar : OUT STD_LOGIC := '1'
    );
END;

ARCHITECTURE behavior OF controller IS
    SIGNAL clk_after_loaded : INTEGER := 0; -- counter
    SIGNAL t_command : STD_LOGIC_VECTOR(command_size - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, command)
    BEGIN
        IF clk_after_loaded = command_size + 1 THEN
            t_command <= command; -- holds the command string
        END IF;

        IF RISING_EDGE(clk) THEN
            IF clk_after_loaded = command_size + 1 THEN
                -- reset
                cs_bar <= '1';
                rd_bar <= '1';
                wr_bar <= '1';
                clk_after_loaded <= 0;

                -- command string will be processed
                operation <= t_command(operation_size - 1 DOWNTO 0);
                address <= t_command(address_size + operation_size - 1 DOWNTO operation_size);
                data <= t_command(command_size - 1 DOWNTO data_size - 1);

                IF t_command(operation_size - 1 DOWNTO 0) = "001" THEN
                    cs_bar <= '0'; -- signal is low in order to read or write data to the memory
                    rd_bar <= '0'; -- signal is low if the operation is memory read
                END IF;

                IF t_command(operation_size - 1 DOWNTO 0) = "101" THEN
                    cs_bar <= '0'; -- signal is low in order to read or write data to the memory
                    wr_bar <= '0'; -- signal is low if the operation is memory write
                END IF;
            ELSE
                clk_after_loaded <= clk_after_loaded + 1; -- increment counter
            END IF;
        END IF;
    END PROCESS;
END;
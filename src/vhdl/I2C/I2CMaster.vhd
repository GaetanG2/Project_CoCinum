library ieee;
use ieee.std_logic_1164.all;

-- An I2C bus master.
entity I2CMaster is
    generic(
        -- The frequency of clk_i.
        CLK_FREQUENCY_HZ : positive;
        -- The desired frequency of sclk_io.
        I2C_FREQUENCY_HZ : positive := 100e3
    );
    port(
        clk_i     : in    std_logic;
        reset_i   : in    std_logic;
        write_i   : in    std_logic;
        address_i : in    std_logic;
        wdata     : in    std_logic_vector(7 downto 0);
        rdata     : out   std_logic_vector(7 downto 0);
        done_o    : out   std_logic;
        scl_io    : inout std_logic;
        sda_io    : inout std_logic
    );
end I2CMaster;

architecture Behavioral of I2CMaster is
    signal scl_i, sda_i, scl_o, sda_o : std_logic;
    signal data_reg : std_logic_vector(7 downto 0);

    type state_t is (IDLE, START_CONDITION, SENDING_BYTE, WAITING_ACK_BYTE, RECEIVING_BYTE, SETTING_ACK, PREPARING_REPEATED_START, REPEATED_START_CONDITION, STOP_CONDITION);
    signal state_reg : state_t;
begin
    p_data_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if write_i = '1' then
                if address_i = '0' then
                    data_reg <= wdata_i;
                end if;
            end if;
        end if;
    end process p_data_reg;

    rdata_o <= data_reg;

    start   <= write_i and wdata_i(0) and address_i;
    restart <= write_i and wdata_i(1) and address_i;

    scl_i  <= to_X01(scl_io);
    sda_i  <= to_X01(sda_io);
    scl_io <= 'Z' when scl_o = '1' else '0';
    sda_io <= 'Z' when sda_o = '1' else '0';

    p_state_reg : process(clk_i)
    begin
        -- ...
    end process p_state_reg;
end Behavioral;

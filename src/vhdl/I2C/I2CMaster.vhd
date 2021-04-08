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
        -- The global clock signal.
        clk_i       : in    std_logic;
        -- The command to start a new data transfer.
        start_i     : in    std_logic;
        -- Indicates that the current transfer is complete.
        done_o      : out   std_logic;
        -- The address of the slave device.
        address_i   : in    std_logic_vector(6 downto 0);
        -- The number of bytes to send to the slave device.
        tx_length_i : in    integer range 0 to 3;
        -- The number of bytes to receive from the slave device.
        rx_length_i : in    integer range 0 to 3;
        -- The data to send to the slave device (aligned left).
        tx_pdata_i  : in    std_logic_vector(23 downto 0);
        -- The data received from the slave device (aligned right).
        rx_pdata_o  : out   std_logic_vector(23 downto 0);
        -- Indicates an I2C transaction error.
        error_o     : out   std_logic;
        -- The I2C serial clock (SCL).
        sclk_io     : inout std_logic;
        -- The I2C serial data (SDA).
        sdata_io    : inout std_logic
    );
end I2CMaster;

architecture Behavioral of I2CMaster is
    -- For simulation, the values of SDA and SCL, converted to logic levels '0' and '1'.
    signal sdata_i, sdata_o : std_logic;
    signal sclk_i, sclk_o   : std_logic;
    -- Sampling time indicators, set when SCL is stable in a low or high state.
    signal sclk_low_pulse   : std_logic;
    signal sclk_high_pulse  : std_logic;
    -- Registers to keep the slave address and data lengths.
    signal address_reg      : std_logic_vector(6 downto 0);
    signal tx_length_reg    : integer range 0 to 3;
    signal rx_length_reg    : integer range 0 to 3;
    -- Shift register used for sending and receiving.
    constant BUFFER_SIZE    : integer := 32;
    signal buffer_reg       : std_logic_vector(BUFFER_SIZE - 1 downto 0);
    -- Time counter that can count one half-period of SCL.
    constant TIMER_MAX      : integer := CLK_FREQUENCY_HZ / I2C_FREQUENCY_HZ / 2 - 1;
    signal timer_reg        : integer range 0 to TIMER_MAX;
    -- The indices of the current bit and byte.
    signal bit_index_reg    : integer range 0 to 7;
    signal byte_index_reg   : integer range 0 to 3;
    -- I2C arbitration error indicator.
    signal arb_error        : std_logic;
    -- The state of the frame sequencer.
    type state_t is (
        IDLE, WAITING_BUS_FREE, WAITING_BUS_FREE_DELAY,
        START_CONDITION,
        SENDING_BYTE, WAITING_ACK_BYTE,
        PREPARING_REPEATED_START, REPEATED_START_CONDITION,
        SENDING_ADDRESS, WAITING_ACK_ADDRESS,
        RECEIVING_BYTE, SETTING_ACK,
        PREPARING_STOP_CONDITION, STOP_CONDITION,
        FRAME_ERROR, FRAME_DONE
    );
    signal state_reg : state_t;
    -- The state of the clock synchronizer.
    type sclk_state_t is (SCL_IDLE, SCL_LOW, SCL_WAITING_HIGH, SCL_HIGH);
    signal sclk_state_reg : sclk_state_t;
begin
    -- Drive the open-drain outputs to SCL and SDA.
    sclk_io  <= '0' when sclk_o  = '0' else 'Z';
    sdata_io <= '0' when sdata_o = '0' else 'Z';

    -- For simulation, convert 'H' (pull-up) levels to '1'.
    sclk_i  <= to_X01(sclk_io);
    sdata_i <= to_X01(sdata_io);

    -- address_i, tx_length_i and rx_length_i are registered
    -- when starting a new frame.
    p_address_tx_rx_length_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            if state_reg = IDLE and start_i = '1' then
                address_reg   <= address_i;
                tx_length_reg <= tx_length_i;
                rx_length_reg <= rx_length_i;
            end if;
        end if;
    end process p_address_tx_rx_length_reg;

    -- Frame sequencer.
    p_state_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            case state_reg is
                when IDLE =>
                    -- Wait for a start command (start_i). A new frame starts
                    -- if there is at least one byte to send or receive.
                    if start_i = '1' then
                        if tx_length_i = 0 and rx_length_i = 0 then
                            state_reg <= FRAME_DONE;
                        else
                            state_reg <= WAITING_BUS_FREE;
                        end if;
                    end if;

                when WAITING_BUS_FREE =>
                    -- Wait until the bus is idle.
                    if sclk_i = '1' and sdata_i = '1' then
                        state_reg <= WAITING_BUS_FREE_DELAY;
                    end if;

                when WAITING_BUS_FREE_DELAY =>
                    -- Wait until the bus idle state has been stable
                    -- for half a second.
                    if sclk_i = '0' or sdata_i = '0' then
                        state_reg <= WAITING_BUS_FREE;
                    elsif timer_reg = TIMER_MAX then
                        state_reg <= START_CONDITION;
                    end if;

                when START_CONDITION =>
                    -- Start a transaction.
                    -- Set SDA to '0' and wait for SCL to fall.
                    if sclk_low_pulse = '1' then
                        if tx_length_reg > 0 then
                            state_reg <= SENDING_BYTE;
                        else
                            state_reg <= SENDING_ADDRESS;
                        end if;
                    end if;

                when SENDING_BYTE =>
                    -- Send an address or data byte.
                    -- Wait until the last bit of the current byte has been sent.
                    -- Detect arbitration errors.
                    if arb_error = '1' then
                        state_reg <= FRAME_ERROR;
                    elsif sclk_low_pulse = '1' and bit_index_reg = 7 then
                        state_reg <= WAITING_ACK_BYTE;
                    end if;

                when WAITING_ACK_BYTE =>
                    -- When SCL rises after the last data bit, the device should
                    -- have set SDA to '0' to acknowledge the latest byte.
                    -- The next operation can be: send a new byte,
                    -- stop the transaction, or initiate a receive sequence.
                    if sclk_i = '1' and sdata_i = '1' then
                        state_reg <= FRAME_ERROR;
                    elsif sclk_low_pulse = '1' then
                        if byte_index_reg /= tx_length_reg then
                            state_reg <= SENDING_BYTE;
                        elsif rx_length_reg = 0 then
                            state_reg <= PREPARING_STOP_CONDITION;
                        else
                            state_reg <= PREPARING_REPEATED_START;
                        end if;
                    end if;

                when PREPARING_REPEATED_START =>
                    -- Prepare a receive sequence.
                    -- SDA is set to '1' while SCL is low.
                    -- The restart condition will happen when SCL is back to '1'.
                    -- Détect arbitration errors.
                    if arb_error = '1' then
                        state_reg <= FRAME_ERROR;
                    elsif sclk_high_pulse = '1' then
                        state_reg <= REPEATED_START_CONDITION;
                    end if;

                when REPEATED_START_CONDITION =>
                    -- Set SDA to '0' while SCL is '1'.
                    -- Wait until SCL is '0' again.
                    if sclk_low_pulse = '1' then
                        state_reg <= SENDING_ADDRESS;
                    end if;

                when SENDING_ADDRESS =>
                    -- Send the address byte in a receive sequence.
                    -- Wait until the last bit has been sent.
                    -- Detect arbitration errors.
                    if arb_error = '1' then
                        state_reg <= FRAME_ERROR;
                    elsif sclk_low_pulse = '1' and bit_index_reg = 7 then
                        state_reg <= WAITING_ACK_ADDRESS;
                    end if;

                when WAITING_ACK_ADDRESS =>
                    -- When SCL rises after the last data bit, the device should
                    -- have set SDA to '0' to acknowledge the latest byte.
                    if sclk_i = '1' and sdata_i = '1' then
                        state_reg <= FRAME_ERROR;
                    elsif sclk_low_pulse = '1' then
                        state_reg <= RECEIVING_BYTE;
                    end if;

                when RECEIVING_BYTE =>
                    -- Receive one data byte.
                    -- Wait until the last bit has been received.
                    if sclk_low_pulse = '1' and bit_index_reg = 7 then
                        state_reg <= SETTING_ACK;
                    end if;

                when SETTING_ACK =>
                    -- Acknowledge the received byte.
                    -- When SCL rises after the last data bit, the master sets SDA to '0'.
                    -- The next operation can be: receive a new byte,
                    -- or stop the transaction.
                    if sclk_low_pulse = '1' then
                        if byte_index_reg /= rx_length_reg then
                            state_reg <= RECEIVING_BYTE;
                        else
                            state_reg <= PREPARING_STOP_CONDITION;
                        end if;
                    end if;

                when PREPARING_STOP_CONDITION =>
                    -- SDA is set to '0' while SCL is '0'.
                    -- The stop condition will happen when SCL is back to '1'.
                    if sclk_high_pulse = '1' then
                        state_reg <= STOP_CONDITION;
                    end if;

                when STOP_CONDITION =>
                    -- SDA is set to '1' while SCL is '1'.
                    -- Wait for half a bit period before signalling completion.
                    if timer_reg = TIMER_MAX then
                        state_reg <= FRAME_DONE;
                    end if;

                when FRAME_ERROR | FRAME_DONE =>
                    -- Set the error or completion indicator outputs
                    -- during one clock cycle.
                    state_reg <= IDLE;
            end case;
        end if;
    end process p_state_reg;

    -- Set the error indicator for one clock period in the FRAME_ERROR state.
    error_o <= '1' when state_reg = FRAME_ERROR else '0';

    -- Indicate that a transaction has completed normally when reaching the FRAME_DONE state.
    -- done_o will be high for one clock cycle.
    done_o <= '1' when state_reg = FRAME_DONE else '0';

    -- Time measurement.
    -- timer_reg can count during half a period of SCL.
    p_timer_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            case state_reg is
                when WAITING_BUS_FREE_DELAY | START_CONDITION | STOP_CONDITION =>
                    -- Count half a period of SCL in the following situations:
                    -- while waiting for the bus to be idle, during start and
                    -- stop conditions.
                    if timer_reg < TIMER_MAX then
                        timer_reg <= timer_reg + 1;
                    else
                        timer_reg <= 0;
                    end if;

                when SENDING_BYTE | WAITING_ACK_BYTE |
                     PREPARING_REPEATED_START | REPEATED_START_CONDITION |
                     SENDING_ADDRESS | WAITING_ACK_ADDRESS |
                     RECEIVING_BYTE | SETTING_ACK | PREPARING_STOP_CONDITION =>
                    -- While sending or receiving data, count the time
                    -- of a low or high SCL state.
                    case sclk_state_reg is
                        when SCL_LOW =>
                            -- When we are setting SCL low, stop counting
                            -- after half a period.
                            if timer_reg < TIMER_MAX then
                                timer_reg <= timer_reg + 1;
                            end if;

                        when SCL_HIGH =>
                            -- When we are releasing SCL, timer_reg counts the
                            -- number of consecutive cycles when SCL is high.
                            -- Reset timer_reg after half a period.
                            if sclk_i = '0' or timer_reg = TIMER_MAX then
                                timer_reg <= 0;
                            else
                                timer_reg <= timer_reg + 1;
                            end if;

                        when SCL_IDLE | SCL_WAITING_HIGH =>
                            -- On start, and when SCL is held low by another master,
                            -- reset timer_reg.
                            timer_reg <= 0;
                    end case;

                when others =>
                    timer_reg <= 0;
            end case;
        end if;
    end process p_timer_reg;

    -- Clock synchronizer.
    p_sclk_state_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            case state_reg is
                when START_CONDITION | SENDING_BYTE | WAITING_ACK_BYTE |
                     PREPARING_REPEATED_START | REPEATED_START_CONDITION |
                     SENDING_ADDRESS | WAITING_ACK_ADDRESS |
                     RECEIVING_BYTE | SETTING_ACK | PREPARING_STOP_CONDITION =>

                    -- The I2C clock is driven from the start condition to
                    -- the phase before the stop condition.
                    case sclk_state_reg is
                        when SCL_IDLE =>
                            -- After the start condition, wait for half a period
                            -- of SCL and pull SCL low.
                            if state_reg = START_CONDITION and timer_reg = TIMER_MAX then
                                sclk_state_reg <= SCL_LOW;
                            end if;

                        when SCL_LOW =>
                            -- Pull SCL low for half a period of SCL.
                            if timer_reg = TIMER_MAX then
                                sclk_state_reg <= SCL_WAITING_HIGH;
                            end if;

                        when SCL_WAITING_HIGH =>
                            -- After releasing SCL, wait until it is actually high.
                            if sclk_i = '1' then
                                sclk_state_reg <= SCL_HIGH;
                            end if;

                        when SCL_HIGH =>
                            -- Release SCL for one half period of SCL.
                            -- If another master pulls it in the meantime,
                            -- continue to state SCL_LOW.
                            if sclk_i = '0' or timer_reg = TIMER_MAX then
                                sclk_state_reg <= SCL_LOW;
                            end if;
                    end case;

                when others =>
                    -- Avant le démarrage de la trame, et à partir de la condition d'arrêt,
                    -- l'horloge I2C est au repos.
                    sclk_state_reg <= SCL_IDLE;
            end case;
        end if;
    end process p_sclk_state_reg;

    -- Pull SCL low in state SCL_LOW, release it in all other states.
    sclk_o <= '0' when sclk_state_reg = SCL_LOW else '1';

    -- Trigger state changes in the middle of each SCL phase.
    -- If there are other masters driving SCL, we assume that their high phase
    -- is at least a quarter of the period of SCL.
    sclk_low_pulse  <= '1' when sclk_state_reg = SCL_LOW  and timer_reg = TIMER_MAX / 2 else '0';
    sclk_high_pulse <= '1' when sclk_state_reg = SCL_HIGH and timer_reg = TIMER_MAX / 2 else '0';

    -- SDA is pulled low during start conditions, repeated start conditions
    -- and master acknowledge. While sending, SDA copies the most significant
    -- bit of the data buffer. Otherwise, SDA is released.
    with state_reg select
        sdata_o <=
            '0' when START_CONDITION | REPEATED_START_CONDITION | SETTING_ACK | PREPARING_STOP_CONDITION | STOP_CONDITION,
            buffer_reg(BUFFER_SIZE - 1) when SENDING_BYTE | SENDING_ADDRESS,
            '1' when others;

    -- An arbitration error is detected when the actual value of SDA is different
    -- from sdata_o while SCL is high.
    -- This signal is checked when sending an address or data bit.
    arb_error <= '1' when sclk_i = '1' and sdata_i /= sdata_o else '0';

    -- The data buffer is implemented as a shift register that contains the
    -- data to send and the received data.
    p_buffer_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            case state_reg is
                when IDLE =>
                    -- When starting a new transaction, the buffer is filled
                    -- with the slave address, a direction bit, and a copy of
                    -- the data to send.
                    if start_i = '1' then
                        buffer_reg(BUFFER_SIZE - 1 downto BUFFER_SIZE - 7) <= address_i;
                        if tx_length_i = 0 then
                            buffer_reg(BUFFER_SIZE - 8) <= '1'; -- Read
                        else
                            buffer_reg(BUFFER_SIZE - 8) <= '0'; -- Write
                        end if;
                        buffer_reg(BUFFER_SIZE - 9 downto 0) <= tx_pdata_i;
                    end if;

                when REPEATED_START_CONDITION =>
                    -- On a repeated start condition, the buffer is filled with
                    -- the slave address and a direction bit in read mode.
                    buffer_reg(BUFFER_SIZE - 1 downto BUFFER_SIZE - 7) <= address_reg;
                    buffer_reg(BUFFER_SIZE - 8) <= '1'; -- Read

                when SENDING_BYTE | SENDING_ADDRESS =>
                    -- While sending, the buffer is shifted left on each low
                    -- phase of SCL.
                    if sclk_low_pulse = '1' then
                        buffer_reg(BUFFER_SIZE - 1 downto 1) <= buffer_reg(BUFFER_SIZE - 2 downto 0);
                        buffer_reg(0) <= '0';
                    end if;

                when RECEIVING_BYTE =>
                    -- While receiving, the buffer is shifted left on each high
                    -- phase of SCL. The current value of SDA is inserted in the
                    -- rightmost location of the buffer.
                    if sclk_high_pulse = '1' then
                        buffer_reg(BUFFER_SIZE - 1 downto 1) <= buffer_reg(BUFFER_SIZE - 2 downto 0);
                        buffer_reg(0) <= sdata_i;
                    end if;

                when others =>
            end case;
        end if;
    end process p_buffer_reg;

    -- The received data output is a direct copy of the buffer.
    -- It is valid until the next transaction.
    rx_pdata_o <= buffer_reg(23 downto 0);

    -- Data bit and byte counters.
    p_bit_byte_index_reg : process(clk_i)
    begin
        if rising_edge(clk_i) then
            case state_reg is
                when IDLE =>
                    bit_index_reg  <= 0;
                    byte_index_reg <= 0;

                when SENDING_BYTE | SENDING_ADDRESS | RECEIVING_BYTE =>
                    -- While sending and receiving, the index of the current bit
                    -- is updated when SCL is low.
                    if sclk_low_pulse = '1' then
                        if bit_index_reg /= 7 then
                            bit_index_reg <= bit_index_reg + 1;
                        else
                            bit_index_reg <= 0;
                        end if;
                    end if;

                when WAITING_ACK_BYTE | WAITING_ACK_ADDRESS =>
                    -- The current byte index is updated during the acknowledge
                    -- cycle when SCL is low.
                    if sclk_low_pulse = '1' and byte_index_reg /= tx_length_reg then
                        byte_index_reg <= byte_index_reg + 1;
                    end if;

                when PREPARING_REPEATED_START =>
                    -- The byte index is reset when starting a receive sequence.
                    byte_index_reg <= 0;

                when SETTING_ACK =>
                    -- The current byte index is updated during the acknowledge
                    -- cycle when SCL is low.
                    if sclk_low_pulse = '1' and byte_index_reg /= rx_length_reg then
                        byte_index_reg <= byte_index_reg + 1;
                    end if;

                when others =>
            end case;
        end if;
    end process p_bit_byte_index_reg;
end Behavioral;

--
-- Banc de test du ma�tre I2C
--
-- Auteur   : Guillaume SAVATON
-- R�vision : 11 janvier 2013
--

library ieee;
use ieee.std_logic_1164.all;

entity I2CMasterTestbench is
end I2CMasterTestbench;

architecture Simulation of I2CMasterTestbench is
    constant CLK_FREQUENCY_HZ : positive := 50e6;
    constant I2C_FREQUENCY_HZ : positive := 100e3;
    constant SLAVE_ADDRESS : std_logic_vector(6 downto 0) := "0101010";
    constant TX_PDATA : std_logic_vector(23 downto 0) := "110010101001011001010011";
    constant RX_PDATA : std_logic_vector(23 downto 0) := not TX_PDATA;
    constant TX_LENGTH : integer := 1;
    constant RX_LENGTH : integer := 0;
    constant CLK_PERIOD : time := 1 sec / CLK_FREQUENCY_HZ;
    constant BIT_PERIOD : time := 1 sec / I2C_FREQUENCY_HZ;
    constant TIMEOUT : time := (TX_LENGTH + RX_LENGTH + 3) * 15 * BIT_PERIOD;
    constant START_TIME : time := 2 * BIT_PERIOD + 0.7 * CLK_PERIOD;
    constant ACKNOWLEDGE_WRITE_ADDRESS : boolean := true;
    constant ACKNOWLEDGE_WRITE_DATA : boolean := true;
    constant ACKNOWLEDGE_READ_ADDRESS : boolean := true;
    constant OTHER_SERIAL_CLOCK : boolean := true;
    constant OTHER_SERIAL_CLOCK_HIGH_TIME : time := BIT_PERIOD * 3 / 4;
    constant OTHER_SERIAL_CLOCK_LOW_TIME : time := BIT_PERIOD * 3 / 4;

    signal clk_sim : std_logic := '0';
    signal start_sim, done_sim, error_sim, sclk_sim, sdata_sim : std_logic;
    signal sclk_bin, sdata_bin : std_logic;
    signal rx_pdata_sim : std_logic_vector(23 downto 0);
begin
    clk_sim <= not clk_sim after CLK_PERIOD / 2;

    start_sim <= '0', '1' after START_TIME, '0' after (START_TIME + CLK_PERIOD);

    master_inst : entity work.I2CMaster
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            I2C_FREQUENCY_HZ => I2C_FREQUENCY_HZ
        )
        port map(
            clk_i       => clk_sim,
            start_i     => start_sim,
            done_o      => done_sim,
            error_o     => error_sim,
            address_i   => SLAVE_ADDRESS,
            tx_length_i => TX_LENGTH,
            rx_length_i => RX_LENGTH,
            tx_pdata_i  => TX_PDATA,
            rx_pdata_o  => rx_pdata_sim,
            sdata_io    => sdata_sim,
            sclk_io     => sclk_sim
        );

    sdata_sim <= 'H';
    sclk_sim  <= 'H';
    sclk_bin    <= to_X01(sclk_sim);
    sdata_bin   <= to_X01(sdata_sim);

    process
    begin
        sclk_sim <= 'Z';
        wait until sclk_bin = '0';
        loop
            if OTHER_SERIAL_CLOCK then
                sclk_sim <= '0';
            end if;
            wait for OTHER_SERIAL_CLOCK_LOW_TIME;
            sclk_sim <= 'Z';
            wait until sclk_bin = '1';
            wait for OTHER_SERIAL_CLOCK_HIGH_TIME;
        end loop;
    end process;

    process
    begin
        sdata_sim <= 'Z';

        if TX_LENGTH > 0 then
            -- Start condition
            wait until sdata_bin = '0' and sclk_bin = '1';

            -- Receive slave address
            for i in 6 downto 0 loop
                wait until rising_edge(sclk_bin);
                assert sdata_bin = SLAVE_ADDRESS(i)
                    report "Slave address not transmitted correctly"
                    severity WARNING;
            end loop;

            -- Receive direction
            wait until rising_edge(sclk_bin);
            assert sdata_bin = '0' -- Transmission
                report "Wrong R/W"
                severity WARNING;

            -- Acknowledge
            wait until falling_edge(sclk_bin);
            if ACKNOWLEDGE_WRITE_ADDRESS then
                sdata_sim <= '0';
            end if;
            wait until rising_edge(sclk_bin);
            wait until falling_edge(sclk_bin);
            sdata_sim <= 'Z';

            for i in 0 to TX_LENGTH-1 loop
                -- Receive data byte
                for j in 0 to 7 loop
                    wait until rising_edge(sclk_bin);
                    assert sdata_bin = TX_PDATA(23 - i * 8 - j)
                        report "Data bit not transmitted correctly"
                        severity WARNING;
                end loop;

                -- Acknowledge
                wait until falling_edge(sclk_bin);
                if ACKNOWLEDGE_WRITE_DATA then
                    sdata_sim <= '0';
                end if;
                wait until rising_edge(sclk_bin);
                wait until falling_edge(sclk_bin);
                sdata_sim <= 'Z';
            end loop;
        end if;

        if RX_LENGTH > 0 then
            -- Repeated start condition
            wait until sdata_bin = '0' and sclk_bin = '1';

            -- Receive slave address
            for i in 6 downto 0 loop
                wait until rising_edge(sclk_bin);
                assert sdata_bin = SLAVE_ADDRESS(i)
                    report "Slave address not transmitted correctly"
                    severity WARNING;
            end loop;

            -- Receive direction
            wait until rising_edge(sclk_bin);
            assert sdata_bin = '1' -- Reception
                report "Wrong R/W"
                severity WARNING;

            -- Acknowledge
            wait until falling_edge(sclk_bin);
            if ACKNOWLEDGE_READ_ADDRESS then
                sdata_sim <= '0';
            end if;
            wait until rising_edge(sclk_bin);

            for i in TX_LENGTH-1 downto 0 loop
                -- Send data byte
                for j in 7 downto 0 loop
                    wait until falling_edge(sclk_bin);
                    if RX_PDATA(i * 8 + j) = '1' then
                        sdata_sim <= 'Z';
                    else
                        sdata_sim <= '0';
                    end if;
                end loop;

                -- Acknowledge
                wait until falling_edge(sclk_bin);
                sdata_sim <= 'Z';
                wait until rising_edge(sclk_bin);
                assert sdata_bin = '0'
                    report "Master did not acknowledge"
                    severity WARNING;
            end loop;
        end if;

        wait;
    end process;

    process
    begin
        wait for TIMEOUT;
        report "Timeout" severity FAILURE;
    end process;

    process
    begin
        wait until error_sim = '1';
        wait for BIT_PERIOD;
        report "I2C error" severity FAILURE;
    end process;

    process
    begin
        wait until done_sim = '1';
        wait for BIT_PERIOD;
        report "Done" severity FAILURE;
    end process;
end Simulation;

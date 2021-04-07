
--
-- Copyright (C), 2020, ESEO
-- Guillaume Savaton <guillaume.savaton@eseo.fr>
--

entity SPIMasterTestbench is
end SPIMasterTestbench;

library ieee;
use ieee.std_logic_1164.all;

use work.SPIMasterTestbench_pkg.all;

architecture Simulation of SPIMasterTestbench is
    constant CLK_PERIOD          : time      := 1 sec / CLK_FREQUENCY_HZ;
    constant SERIAL_CLOCK_PERIOD : time      := 1 sec / BIT_RATE_HZ;
    constant DATA_WIDTH          : positive  := 8;
    signal clk                   : std_logic := '0';
    signal reset                 : std_logic := '1';
    signal write                 : std_logic := '0';
    signal done                  : std_logic;
    signal rdata                 : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal wdata                 : std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal miso                  : std_logic;
    signal mosi                  : std_logic;
    signal sclk                  : std_logic;

    function to_string(slv : std_logic_vector) return string is
        variable img    : string(1 to 3);
        variable result : string(1 to slv'length + 2);
        variable j      : integer range 1 to slv'length + 2;
    begin
        result(1) := '"';
        j := 2;
        for i in slv'range loop
            img := std_logic'image(slv(i));
            result(j) := img(2);
            j := j + 1;
        end loop;
        result(slv'length + 2) := '"';
        return result;
    end to_string;
begin
    master_inst : entity work.SPIMaster
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BIT_RATE_HZ      => BIT_RATE_HZ,
            DATA_WIDTH       => DATA_WIDTH,
            POLARITY         => POLARITY,
            PHASE            => PHASE
        )
        port map(
            clk_i   => clk,
            reset_i => reset,
            write_i => write,
            done_o  => done,
            sclk_o  => sclk,
            wdata_i => wdata,
            rdata_o => rdata,
            mosi_o  => mosi,
            miso_i  => miso
        );

    clk   <= not clk after CLK_PERIOD / 2;
    reset <= '0' after CLK_PERIOD;

    -- ------------------------------------------------------------------------
    -- Master to slave
    -- ------------------------------------------------------------------------

    wdata <= DATA_TO_SLAVE;
    write <= '1' after 2 * CLK_PERIOD, '0' after 3 * CLK_PERIOD;

    p_check_mosi : process
    begin
        wait until sclk = POLARITY;

        for i in DATA_WIDTH - 1 downto 0 loop
            if PHASE = '0' then
                wait until sclk'event and sclk /= POLARITY;
            else
                wait until sclk'event and sclk = POLARITY;
            end if;

            assert mosi = DATA_TO_SLAVE(i)
                report "sdata_o: " & std_logic'image(mosi) & "; expected: " & std_logic'image(DATA_TO_SLAVE(i))
                severity ERROR;

            assert mosi'stable
                report "sdata_o: unstable"
                severity ERROR;
        end loop;
    end process p_check_mosi;

    p_check_sclk : process
        variable t : time;
    begin
        wait until sclk /= 'U';

        assert sclk = POLARITY
            report "sclk_o: " & std_logic'image(sclk) & "; expected: " & std_logic'image(POLARITY)
            severity ERROR;

        wait until sclk'event;
        t := now;

        for i in 1 to 2 * DATA_WIDTH - 1 loop
            wait until sclk'event;

            assert now = t + SERIAL_CLOCK_PERIOD / 2
                report "sclk_o, invalid period: " & time'image((now - t) * 2) & "; expected: " & time'image(SERIAL_CLOCK_PERIOD)
                severity ERROR;

            t := now;
        end loop;
    end process p_check_sclk;

    -- ------------------------------------------------------------------------
    -- Slave to master
    -- ------------------------------------------------------------------------

    p_miso : process
    begin
        wait until sclk = POLARITY;

        for i in DATA_WIDTH - 1 downto 0 loop
            if PHASE = '0' then
                miso <= DATA_FROM_SLAVE(i);
                wait until sclk'event and sclk = POLARITY;
            else
                wait until sclk'event and sclk /= POLARITY;
                miso <= DATA_FROM_SLAVE(i);
            end if;
        end loop;

        wait;
    end process p_miso;

    p_check_rdata : process
    begin
        wait until rising_edge(clk) and done = '1';

        assert rdata = DATA_FROM_SLAVE
            report "pdata_o : " & to_string(rdata) & "; expected: " & to_string(DATA_FROM_SLAVE)
            severity ERROR;
    end process p_check_rdata;
end Simulation;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Virgule_pkg.all;
use work.Computer_pkg.all;

entity Computer is
    port(
        clk_i        : in  std_logic;
        btn_center_i : in  std_logic;
        switches_i   : in  std_logic_vector(15 downto 0);
        leds_o       : out std_logic_vector(15 downto 0);
        uart_rx_i    : in  std_logic;
        uart_tx_o    : out std_logic;
        
        -- Ports pour Joystick
        pmod_b1    : out std_logic;
        pmod_b2    : out std_logic;
        pmod_b3    : in std_logic;
        pmod_b4    : out std_logic;
        pmod_b7    : out std_logic;
        pmod_b8    : out std_logic;
        pmod_b9    : out std_logic;
        pmod_b10    : out std_logic;
        
        -- Ports pour Ecran OLED
        pmod_c1    : out std_logic;
        pmod_c2    : out std_logic;
        pmod_c3    : in std_logic;
        pmod_c4    : out std_logic;
        pmod_c7    : out std_logic;
        pmod_c8    : out std_logic;
        pmod_c9    : out std_logic;
        pmod_c10    : out std_logic
        
        
    );
end Computer;

architecture Structural of Computer is
    signal sync_reset    : std_logic;
    
    signal sync_uart_rx  : std_logic;
    signal uart_valid    : std_logic;
    signal uart_ready    : std_logic;
    signal uart_rdata    : std_logic_vector(31 downto 0);
    signal uart_tx_evt   : std_logic;
    signal uart_rx_evt   : std_logic;
    signal irq_o         : std_logic;
    
    signal intc_valid    : std_logic;
    signal intc_ready    : std_logic;
    signal intc_rdata    : word_t;
    signal intc_events   : std_logic_vector(6 downto 0);
    
    signal core_valid    : std_logic;
    signal core_ready    : std_logic;
    signal core_address  : word_t;
    signal core_rdata    : word_t;
    signal core_wdata    : word_t;
    signal core_write    : std_logic_vector(3 downto 0);
    signal core_irq      : std_logic;

    alias dev_address    : byte_t is core_address(31 downto 24);

    signal mem_valid     : std_logic;
    signal mem_ready     : std_logic;
    signal mem_rdata     : word_t;

    signal io_valid      : std_logic;
    signal io_ready      : std_logic;
    signal io_rdata      : word_t;
    
    signal timer_valid    : std_logic;
    signal timer_ready    : std_logic;
    signal timer_rdata    : word_t;
    signal timer_event   : std_logic;
    
    signal evt_o          : std_logic;
    signal sync_spi_miso_b   : std_logic;
    signal sync_spi_miso_c   : std_logic;
    
    
    -- SPI pour Joystick
    signal spi_timer_b_valid    : std_logic;
    signal spi_master_b_valid    : std_logic;
    signal spi_master_b_ready    : std_logic;
    signal spi_timer_b_ready    : std_logic;
    signal spi_timer_b_rdata : word_t;
    signal spi_master_b_rdata    : word_t;
    signal spi_b_event   : std_logic;
    signal spi_timer_b_event   : std_logic;
    signal spi_master_b_event   : std_logic;
    
    -- SPI pour Ecran OLED
    signal spi_timer_c_valid    : std_logic;
    signal spi_master_c_valid    : std_logic;
    signal spi_master_c_ready    : std_logic;
    signal spi_timer_c_ready    : std_logic;
    signal spi_timer_c_rdata : word_t;
    signal spi_master_c_rdata    : word_t;
    signal spi_c_event   : std_logic;
    signal spi_timer_c_event   : std_logic;
    signal spi_master_c_event   : std_logic;
    
begin
    -- Concurrent statements
    core_inst : entity work.Virgule(rtl)
        port map(
          clk_i => clk_i,
          reset_i => sync_reset,
          valid_o => core_valid,
          ready_i => core_ready ,
          address_o => core_address,
          write_o => core_write,
          wdata_o => core_wdata,
          rdata_i => core_rdata,
          irq_i => core_irq
        );
    mem_inst : entity work.VMemory(Behavioral)
        generic map (
            CONTENT => MEM_CONTENT
        )
        port map (
            valid_i => mem_valid,
            ready_o => mem_ready,
            address_i => core_address(31 downto 2),
            write_i => core_write,
            wdata_i => core_wdata,
            rdata_o => mem_rdata,
            clk_i => clk_i,
            reset_i => sync_reset
        );
    sync_inst : entity work.InputSynchronizer(Behavioral)
        generic map (
            WIDTH => 20            
        )
        port map (
            data_i(0) => btn_center_i,
            data_i(16 downto 1) => switches_i,
            data_i(17) => uart_rx_i,
            data_i(18) => pmod_b3,
            data_i(19) => pmod_c3,
            
            data_o(0) => sync_reset,
            data_o(16 downto 1) => io_rdata(15 downto 0),
            data_o(17) => sync_uart_rx,
            data_o(18) => sync_spi_miso_b,
            data_o(19) => sync_spi_miso_c,
            clk_i => clk_i         
            
        );
    
    uart_inst : entity work.UART(Structural)
        generic map(
            CLK_FREQUENCY_HZ => CLK_FREQUENCY_HZ,
            BIT_RATE_HZ => UART_BIT_RATE_HZ
        )
        port map (
            valid_i => uart_valid,
            ready_o => uart_ready,
            write_i => core_write(0),
            wdata_i => core_wdata(7 downto 0),
            rdata_o => uart_rdata(7 downto 0),
            clk_i => clk_i,
            reset_i => sync_reset,
            tx_o => uart_tx_o,
            rx_i => sync_uart_rx,
            tx_evt_o => uart_tx_evt,
            rx_evt_o => uart_rx_evt
        );
        
    intc_inst : entity work.VInterruptController(Behavioral)
        port map (
            valid_i => intc_valid,
            ready_o => intc_ready,
            write_i => core_write,
            wdata_i => core_wdata,
            rdata_o => intc_rdata,
            clk_i => clk_i,
            reset_i => sync_reset,
            address_i => core_address(2),
            irq_o => core_irq,
            events_i => intc_events
        );
    
    timer_inst : entity work.Timer(Behavioral)
        port map (
            valid_i => timer_valid,
            ready_o => timer_ready,
            write_i => core_write,
            wdata_i => core_wdata,
            rdata_o => timer_rdata,
            clk_i => clk_i,
            reset_i => sync_reset,
            address_i => core_address(2),
            evt_o => timer_event
        );
    
    -- timer SPI pour le Joystick
    spi_timer_b_inst : entity work.Timer(Behavioral)
        port map (
            valid_i => spi_timer_b_valid,
            ready_o => spi_timer_b_ready,
            write_i => core_write,
            wdata_i => core_wdata,
            rdata_o => spi_timer_b_rdata,
            clk_i => clk_i,
            reset_i => sync_reset,
            address_i => core_address(2),
            evt_o => spi_timer_b_event
        );
    
    -- timer SPI pour Ecran OLED
    spi_timer_c_inst : entity work.Timer(Behavioral)
        port map (
            valid_i => spi_timer_c_valid,
            ready_o => spi_timer_c_ready,
            write_i => core_write,
            wdata_i => core_wdata,
            rdata_o => spi_timer_c_rdata,
            clk_i => clk_i,
            reset_i => sync_reset,
            address_i => core_address(2),
            evt_o => spi_timer_c_event
        );
    
    -- Bus SPI pour Joystick
    spi_b_inst : entity work.SPIMaster(rtl)
        port map (
            valid_i => spi_master_b_valid,
            ready_o => spi_master_b_ready,
            write_i => core_write(0),
            wdata_i => core_wdata(7 downto 0),
            rdata_o => spi_master_b_rdata(7 downto 0),
            clk_i => clk_i,
            reset_i => sync_reset,
            address_i => core_address(3 downto 2),
            evt_o => spi_master_b_event,
            miso_i => sync_spi_miso_b,
            mosi_o => pmod_b2,
            sclk_o => pmod_b4,
            cs_n_o => pmod_b1
        );
        
    -- Bus SPI pour Ecran OLED
    spi_c_inst : entity work.SPIMaster(rtl)
        port map (
            valid_i => spi_master_c_valid,
            ready_o => spi_master_c_ready,
            write_i => core_write(0),
            wdata_i => core_wdata(7 downto 0),
            rdata_o => spi_master_c_rdata(7 downto 0),
            clk_i => clk_i,
            reset_i => sync_reset,
            address_i => core_address(3 downto 2),
            evt_o => spi_master_c_event,
            miso_i => sync_spi_miso_c,
            mosi_o => pmod_c2,
            sclk_o => pmod_c4,
            cs_n_o => pmod_c1
        );
    
    with dev_address select
        core_rdata <=   mem_rdata when MEM_ADDRESS,
                        io_rdata when IO_ADDRESS,
                        uart_rdata when UART_ADDRESS,
                        intc_rdata when INTC_ADDRESS,
                        timer_rdata when TIMER_ADDRESS,
                        spi_timer_b_rdata when SPI_TIMER_B_ADDRESS,
                        spi_master_b_rdata when SPI_MASTER_B_ADDRESS,
                        spi_timer_c_rdata when SPI_TIMER_C_ADDRESS,
                        spi_master_c_rdata when SPI_MASTER_C_ADDRESS,
                        (others => '0') when others;
                        
    with dev_address select
        core_ready <=   uart_ready when UART_ADDRESS,
                        intc_ready when INTC_ADDRESS,
                        mem_ready when MEM_ADDRESS,
                        timer_ready when TIMER_ADDRESS,
                        spi_timer_b_ready when SPI_TIMER_B_ADDRESS,
                        spi_master_b_ready when SPI_MASTER_B_ADDRESS,
                        spi_timer_c_ready when SPI_TIMER_C_ADDRESS,
                        spi_master_c_ready when SPI_MASTER_C_ADDRESS,
                        core_valid when others; 
    
    io_rdata(31 downto 16) <= (others => '0');
    uart_rdata(31 downto 8) <= (others => '0');
 --   timer_rdata <= limit_reg when core_address(0) = '0'else count_reg;
 --   timer_event <= '1' when (count_reg >= limit_reg and limit_reg /= "00000000000000000000000000000000");
    
    mem_valid <= core_valid when dev_address = MEM_ADDRESS else '0';
    
    io_valid <= core_valid when dev_address = IO_ADDRESS else '0';
    
    uart_valid <= core_valid when dev_address = UART_ADDRESS else '0';
    
    intc_valid <= core_valid when dev_address = INTC_ADDRESS else '0';
    
    timer_valid <= core_valid when dev_address = TIMER_ADDRESS else '0';
    
    spi_timer_b_valid <= core_valid when (dev_address = SPI_TIMER_B_ADDRESS) else '0';
    
    spi_master_b_valid <= core_valid when (dev_address = SPI_MASTER_B_ADDRESS) else '0';
    
    spi_timer_c_valid <= core_valid when (dev_address = SPI_TIMER_C_ADDRESS) else '0';
    
    spi_master_c_valid <= core_valid when (dev_address = SPI_MASTER_C_ADDRESS) else '0';
    
    
    --core_ready <= uart_ready when dev_address = UART_ADDRESS else core_valid;
    
    
    --core_ready <= intc_ready when dev_address = INTC_ADDRESS else core_valid;
    
    intc_events(INTC_EVENTS_UART_RX) <= uart_rx_evt;
    intc_events(INTC_EVENTS_UART_TX) <= uart_tx_evt;
    intc_events(INTC_EVENTS_TIMER) <= timer_event;
    intc_events(INTC_EVENTS_SPI_TIMER_B) <= spi_timer_b_event;
    intc_events(INTC_EVENTS_SPI_MASTER_B) <= spi_master_b_event;
    intc_events(INTC_EVENTS_SPI_TIMER_C) <= spi_timer_c_event;
    intc_events(INTC_EVENTS_SPI_MASTER_C) <= spi_master_c_event;
    
    
    --core_ready <= mem_ready when dev_address = MEM_ADDRESS else core_valid;
    
    p_leds_7_0 : process(clk_i, sync_reset)
    begin
        if sync_reset = '1' then
            leds_o(7 downto 0) <= (others => '0');
        elsif rising_edge(clk_i) then
            if (core_write(0) and io_valid) = '1' then
                leds_o(7 downto 0) <= core_wdata(7 downto 0);
            end if;
        end if;
    end process  p_leds_7_0;
    

--    p_timer : process(clk_i, sync_reset)
--        begin
--            if sync_reset = '1' then
--                limit_reg <= (others => '0');
--                count_reg <= (others => '0');
--            else
--                if rising_edge(clk_i)then
--                    if core_write(3 downto 0) /= "0000" and timer_valid = '1' then 
--                            if core_address(0) = '0' then
--                                limit_reg <= core_wdata;
--                            elsif core_address(0) = '1'then
--                                count_reg <= core_wdata;
--                            end if;
--                    else 
--                        if count_reg >= limit_reg then
--                            count_reg <= (others => '0');
--                        else
--                            count_reg <= std_logic_vector(unsigned(count_reg) + 1);
--                        end if;
--                    end if;
--                 end if;
--            end if;
--    end process  p_timer;

    
    
    p_leds_15_8 : process(clk_i, sync_reset)
    begin
        if sync_reset = '1' then
            leds_o(15 downto 8) <= (others => '0');
        elsif rising_edge(clk_i) then
            if (core_write(1) and io_valid) = '1' then
                leds_o(15 downto 8) <= core_wdata(15 downto 8);
            end if;
        end if;
    end process  p_leds_15_8;
    
    p_mod_c : process(clk_i, sync_reset)
    begin
        if sync_reset = '1' then
            pmod_c7 <= '0';
            pmod_c8 <= '0';
            pmod_c9 <= '0';
            pmod_c10 <= '0';
        elsif rising_edge(clk_i) then
            if (core_write(2) and io_valid) = '1' then
                pmod_c7 <= core_wdata(16);
                pmod_c8 <= core_wdata(17);
                pmod_c9 <= core_wdata(18);
                pmod_c10 <= core_wdata(19);
            end if;
        end if;
    end process  p_mod_c;
    
end Structural;

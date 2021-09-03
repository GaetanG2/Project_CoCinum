
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Virgule_pkg.all;
use work.Computer_pkg.all;

entity Computer is
    port(
        clk_i        : in  std_logic;
        btn_center_i : in  std_logic;
        uart_tx_o    : out std_logic;
        uart_rx_i    : in  std_logic
    );
end Computer;

architecture Structural of Computer is
    signal sync_reset     : std_logic;
    signal sync_uart_rx   : std_logic;

    signal core_valid     : std_logic;
    signal core_ready     : std_logic;
    signal core_address   : word_t;
    signal core_rdata     : word_t;
    signal core_wdata     : word_t;
    signal core_write     : std_logic_vector(3 downto 0);
    signal core_irq       : std_logic;

    signal current_device : device_t;

    signal mem_valid      : std_logic;
    signal mem_ready      : std_logic;
    signal mem_rdata      : word_t;

    signal intc_valid     : std_logic;
    signal intc_ready     : std_logic;
    signal intc_rdata     : word_t;
    signal intc_events    : word_t;

    signal uart_valid     : std_logic;
    signal uart_ready     : std_logic;
    signal uart_rdata     : word_t;
    signal uart_tx_evt    : std_logic;
    signal uart_rx_evt    : std_logic;
begin
    -- Concurrent statements
end Structural;

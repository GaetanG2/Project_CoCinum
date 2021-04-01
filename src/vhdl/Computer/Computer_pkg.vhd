
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Virgule_pkg.all;

package Computer_pkg is

    constant CLK_FREQUENCY_HZ    : positive      := 100e6;

    constant MEM_ADDRESS         : unsigned      := x"00000000";
    constant MEM_CONTENT         : word_vector_t := work.Loader_pkg.DATA;
    constant MEM_SIZE            : positive      := 4 * MEM_CONTENT'length;

    constant INTC_ADDRESS        : unsigned      := x"81000000";
    constant INTC_SIZE           : positive      := 8;

    constant UART_ADDRESS        : unsigned      := x"82000000";
    constant UART_BIT_RATE_HZ    : positive      := 115200;

    constant INTC_EVENTS_UART_RX : natural       := 0;
    constant INTC_EVENTS_UART_TX : natural       := 1;

    type device_t is (NONE, MEM, INTC, UART);
    
end Computer_pkg;

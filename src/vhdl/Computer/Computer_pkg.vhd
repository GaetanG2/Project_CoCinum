
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Virgule_pkg.all;

package Computer_pkg is

    constant CLK_FREQUENCY_HZ : positive      := 100e6;

    constant MEM_ADDRESS      : byte_t        := x"00";
    constant MEM_CONTENT      : word_vector_t := work.Loader_pkg.DATA;

    constant IO_ADDRESS       : byte_t        := x"80";
    
    constant INTC_ADDRESS     : byte_t        := x"81";

    constant UART_ADDRESS     : byte_t        := x"82";
    
    constant UART_BIT_RATE_HZ : positive      := 115200;
    
    constant INTC_EVENTS_UART_RX : natural   := 0;
    
    constant INTC_EVENTS_UART_TX : natural   := 1;
    
    constant TIMER_ADDRESS    : byte_t        := x"83";
    
    constant INTC_EVENTS_TIMER: natural       := 2;
    
    constant SPI_TIMER_B_ADDRESS: byte_t        := x"84";
    constant SPI_MASTER_B_ADDRESS: byte_t        := x"85";
    
    constant SPI_TIMER_C_ADDRESS: byte_t        := x"86";
    constant SPI_MASTER_C_ADDRESS: byte_t        := x"87";
    
    constant INTC_EVENTS_SPI_TIMER_B : natural   := 3;
    
    constant INTC_EVENTS_SPI_MASTER_B : natural   := 4;
    
    constant INTC_EVENTS_SPI_TIMER_C : natural   := 5;
    
    constant INTC_EVENTS_SPI_MASTER_C : natural   := 6;
end Computer_pkg;

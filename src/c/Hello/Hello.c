
#include <Platform/Platform.h>

__attribute__((interrupt("machine"))) void irq_handler(void) {
    UART_irq_handler(uart);
}

void main(void) {
    UART_init(uart);
    UART_puts(uart, "Virgule says\n<< Hello! >>\nfrom C.\n");
    while (uart->tx_busy);
}

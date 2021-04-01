
#include "UART.h"

void UART_init(UART *dev) {
    InterruptController_disable(dev->intc, dev->tx_irq_mask | dev->rx_irq_mask);
    InterruptController_clear_events(dev->intc, dev->tx_irq_mask | dev->rx_irq_mask);
}

void UART_putc(UART *dev, uint8_t c) {
    *dev->data = c;
    while (!InterruptController_has_events(dev->intc, dev->tx_irq_mask));
    InterruptController_clear_events(dev->intc, dev->tx_irq_mask);
}

uint8_t UART_getc(UART *dev) {
    while (!InterruptController_has_events(dev->intc, dev->rx_irq_mask));
    InterruptController_clear_events(dev->intc, dev->rx_irq_mask);
    return *dev->data;
}

void UART_puts(UART *dev, const uint8_t *s) {
    while (*s) {
        UART_putc(dev, *s ++);
    }
}

void UART_irq_handler(UART *dev) {
    // Empty
}

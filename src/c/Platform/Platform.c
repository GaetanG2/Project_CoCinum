
#include "Platform.h"
#include "Platform-config.h"

InterruptController *const intc = (InterruptController*)INTC_ADDRESS;

static UART uart_priv = {
    .intc        = intc,
    .rx_irq_mask = UART_RX_IRQ_MASK,
    .tx_irq_mask = UART_TX_IRQ_MASK,
    .data        = (uint8_t*)UART_ADDRESS
};

UART *const uart = &uart_priv;

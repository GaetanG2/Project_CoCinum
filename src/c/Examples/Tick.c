
#include "Platform.h"

static volatile unsigned tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_events(timer1)) {
        tick ++;
        Timer_clear_event(timer1);
    }
}

void main(void) {
    UART_init(uart);

    UART_puts(uart, "Press a key to terminate.\n");

    Timer_init(timer1);
    Timer_set_limit(timer1, CLK_FREQUENCY_HZ / 2);
    Timer_enable_interrupts(timer1);

    tick = 0;
    unsigned tock = 0;

    while (!UART_has_data(uart)) {
        if (tick != tock) {
            UART_puts(uart, "Tick\n");
            tock ++;
        }
    }
}

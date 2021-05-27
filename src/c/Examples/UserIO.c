
#include "Platform.h"

static volatile unsigned tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_events(timer1)) {
        Timer_clear_event(timer1);
        tick ++;
    }
}

void main(void) {
    UART_init(uart);

    UART_puts(uart, "Press a key to terminate.\n");

    Timer_init(timer1);
    Timer_set_limit(timer1, CLK_FREQUENCY_HZ / 2);
    Timer_enable_interrupts(timer1);

    UserInputs_init(btns);

    tick = 0;
    unsigned tock = 0;

    uint16_t btns_last_events = 0;

    while (!UART_has_data(uart)) {
        if (tick != tock) {
            *leds = UserInputs_get_status(btns) ^ btns_last_events;
            btns_last_events = 0;
            if (UserInputs_has_events(btns)) {
                UART_puts(uart, "Changed\n");
                btns_last_events = UserInputs_get_on_events(btns) | UserInputs_get_off_events(btns);
                UserInputs_clear_events(btns);
            }
            tock ++;
        }
    }
}

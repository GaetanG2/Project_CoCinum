
#include "Platform.h"

static volatile unsigned tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_events(timer3)) {
        Timer_clear_event(timer3);
        tick ++;
    }
}

static void print_hex(uint32_t n, size_t size) {
    size <<= 3;
    while (size) {
        size -= 4;
        uint8_t digit = (n >> size) & 0xF;
        if (digit < 10) {
            digit += '0';
        }
        else {
            digit += 'A' - 10;
        }
        UART_putc(uart, digit);
    }
}

void main(void) {
    UART_init(uart);
    UART_puts(uart, "Expected hardware:\nPmodA: PmodJSTK2\nPress a key to terminate.\n");

    Timer_init(timer3);
    Timer_set_limit(timer3, CLK_FREQUENCY_HZ / 2);
    Timer_enable_interrupts(timer3);

    Joystick_init(jstk);

    tick = 0;
    unsigned tock = 0;

    JoystickState jstk_state;

    while (!UART_has_data(uart)) {
        if (tick != tock) {
            jstk_state.red   = (tock & 4) << 5;
            jstk_state.green = (tock & 2) << 6;
            jstk_state.blue  = (tock & 1) << 7;

            Joystick_update(jstk, &jstk_state);

            UART_puts(uart, "Joystick: x=");
            print_hex(jstk_state.x, sizeof(jstk_state.x));

            UART_puts(uart, " y=");
            print_hex(jstk_state.y, sizeof(jstk_state.y));

            if (jstk_state.trigger) {
                UART_puts(uart, " T");
            }
            if (jstk_state.pressed) {
                UART_puts(uart, " J");
            }

            UART_putc(uart, '\n');

            tock ++;
        }
    }
}


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
    UART_puts(uart, "Expected hardware:\nPmodB: PmodACL2\nPress a key to terminate.\n");

    Timer_init(timer3);
    Timer_set_limit(timer3, CLK_FREQUENCY_HZ / 2);
    Timer_enable_interrupts(timer3);

    Accelerometer_init(acl);

    tick = 0;
    unsigned tock = 0;

    AccelerometerState acl_state;

    while (!UART_has_data(uart)) {
        if (tick != tock) {
            Accelerometer_update(acl, &acl_state);
            UART_puts(uart, "Accelerometer: x=");
            print_hex(acl_state.x, sizeof(acl_state.x));
            UART_puts(uart, " y=");
            print_hex(acl_state.y, sizeof(acl_state.y));
            UART_puts(uart, " z=");
            print_hex(acl_state.z, sizeof(acl_state.z));
            UART_puts(uart, " t=");
            print_hex(acl_state.t, sizeof(acl_state.t));
            UART_putc(uart, '\n');

            tock ++;
        }
    }
}

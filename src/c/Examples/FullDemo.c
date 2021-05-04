
#include "Platform.h"

static uint16_t count;
static uint16_t points;
static uint16_t leds_last, leds_next;
static JoystickState jstk_state;
static AccelerometerState acl_state;

static volatile bool tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_events(timer3)) {
        tick = true;
        count ++;
        points <<= 1;
        if (points > 8) {
            points = 1;
        }

        leds_last = leds_next;
        leds_next = 0;

        jstk_state.red   = (count & 4) << 5;
        jstk_state.green = (count & 2) << 6;
        jstk_state.blue  = (count & 1) << 7;

        Timer_clear_event(timer3);
    }

    if (UserInputs_has_events(btns)) {
        leds_next |= UserInputs_get_on_events(btns) | UserInputs_get_off_events(btns);
        UserInputs_clear_events(btns);
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
    UART_puts(uart, "Expected hardware:\nPmodA: PmodJSTK2\nPmodB: PmodACL2\nPress a key to terminate.\n");

    count     = 0;
    points    = 1;
    leds_last = leds_next = 0;
    tick      = false;

    SegmentDisplay_show(display, count, points);

    Timer_init(timer3);
    Timer_set_limit(timer3, CLK_FREQUENCY_HZ / 2);
    Timer_enable_interrupts(timer3);

    UserInputs_init(btns);
    UserInputs_enable_interrupts(btns);

    Joystick_init(jstk);
    Accelerometer_init(acl);

    while (!UART_has_data(uart)) {
        if (tick) {
            tick = false;
            SegmentDisplay_show(display, count, points);

            *leds = leds_last;

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
        }
    }
}

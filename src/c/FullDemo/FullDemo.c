
#include <Platform/Platform.h>
#include <SPI/Joystick.h>
#include <SPI/Accelerometer.h>
#include <stddef.h>

static uint16_t count;
static uint16_t points;
static uint16_t leds_last, leds_next;
static uint8_t jstk_red, jstk_green, jstk_blue;

static volatile bool tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_event(timer1)) {
        tick = true;
        count ++;
        points <<= 1;
        if (points > 8) {
            points = 1;
        }

        leds_last = leds_next;
        leds_next = 0;

        jstk_red   = (count & 4) << 5;
        jstk_green = (count & 2) << 6;
        jstk_blue  = (count & 1) << 7;

        Timer_clear_event(timer1);
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

    Timer_init(timer1);
    Timer_set_limit(timer1, CLK_FREQUENCY_HZ / 2);
    Timer_irq_enable(timer1);

    UserInputs_init(btns);
    UserInputs_irq_enable(btns);

    Joystick_init(jstk);
    // Accelerometer_init(spi2);

    while (!UART_has_data(uart)) {
        if (tick) {
            tick = false;
            SegmentDisplay_show(display, count, points);

            *leds = leds_last;

            uint16_t x, y;
            bool trigger, pressed;
            Joystick_update(jstk, jstk_red, jstk_green, jstk_blue, &x, &y, &trigger, &pressed);

            UART_puts(uart, "x=");
            print_hex(x, sizeof(x));
            UART_puts(uart, " y=");
            print_hex(y, sizeof(y));
            if (trigger) {
                UART_puts(uart, " T");
            }
            if (pressed) {
                UART_puts(uart, " J");
            }
            UART_putc(uart, '\n');
        }
    }
}

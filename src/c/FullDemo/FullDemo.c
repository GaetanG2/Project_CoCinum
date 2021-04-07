
#include <Platform/Platform.h>
#include <SPI/Joystick.h>
#include <SPI/Accelerometer.h>

static uint16_t count;
static uint16_t points;
static uint16_t leds_last, leds_next;
static uint8_t jstk_red, jstk_green, jstk_blue;

static volatile bool tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_event(timer)) {
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

        Timer_clear_event(timer);
    }

    if (UserInputs_has_events(btns)) {
        leds_next |= UserInputs_get_on_events(btns) | UserInputs_get_off_events(btns);
        UserInputs_clear_events(btns);
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

    Timer_init(timer);
    Timer_set_limit(timer, CLK_FREQUENCY_HZ / 2);
    Timer_irq_enable(timer);

    UserInputs_init(btns);
    UserInputs_irq_enable(btns);

    Joystick_init(spi1);
    // Accelerometer_init(spi2);

    while (!UART_has_data(uart)) {
        if (tick) {
            tick = false;
            SegmentDisplay_show(display, count, points);

            *leds = leds_last;

            uint16_t x, y;
            bool trigger, pressed;
            Joystick_update(spi1, jstk_red, jstk_green, jstk_blue, &x, &y, &trigger, &pressed);
        }
    }
}

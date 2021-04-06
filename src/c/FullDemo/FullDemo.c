
#include <Platform/Platform.h>

static uint16_t count;
static uint16_t points;
static uint16_t leds_next;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_event(timer)) {
        count ++;
        points <<= 1;
        if (points > 8) {
            points = 1;
        }
        SegmentDisplay_show(display, count, points);

        *leds = leds_next;
        leds_next = 0;

        Timer_clear_event(timer);
    }

    if (UserInputs_has_events(btns)) {
        leds_next |= UserInputs_get_on_events(btns) | UserInputs_get_off_events(btns);
        UserInputs_clear_events(btns);
    }
}

void main(void) {
    UART_init(uart);
    UART_puts(uart, "Virgule says\n<< Hello! >>\nPress a key to terminate.\n");

    count     = 0;
    points    = 1;
    leds_next = 0;

    SegmentDisplay_show(display, count, points);

    Timer_init(timer);
    Timer_set_limit(timer, CLK_FREQUENCY_HZ / 2);
    Timer_irq_enable(timer);

    UserInputs_init(btns);
    UserInputs_irq_enable(btns);

    while (!UART_has_data(uart));
}

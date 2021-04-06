
#include <Platform/Platform.h>

#define POINT_INDEX_MAX 3

static uint16_t count;
static uint16_t points;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);

    if (Timer_has_event(timer)) {
        Timer_clear_event(timer);
        count ++;
        points <<= 1;
        if (points > 8) {
            points = 1;
        }
        SegmentDisplay_show(display, count, points);
        *leds = 0;
    }

    if (UserInputs_has_event(btns)) {
        *leds = *btns->on_evt;
        UserInputs_clear_event(btns);
    }
}

void main(void) {
    UART_init(uart);
    UART_puts(uart, "Virgule says\n<< Hello! >>\nPress a key to terminate.\n");

    count  = 0;
    points = 1;
    SegmentDisplay_show(display, count, points);

    Timer_init(timer);
    Timer_set_limit(timer, CLK_FREQUENCY_HZ);
    Timer_irq_enable(timer);

    UserInput_init(btns);
    UserInputs_irq_enable(btns);

    while (!UART_has_data(uart));
}

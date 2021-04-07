
#include <Platform/Platform-config.h>
#include "Joystick.h"

#define JSTK_SET_LED_RGB 0x84

#define JSTK_TRIGGER_MASK 2
#define JSTK_PRESSED_MASK 1

void Joystick_init(Joystick *dev) {
    SPIMaster_init(dev->spi, 0, 0, CLK_FREQUENCY_HZ / 1000000 - 1);
    Timer_init(dev->timer);
    Timer_set_limit(dev->timer, CLK_FREQUENCY_HZ / 40000);
}

void Joystick_update(Joystick *dev, uint8_t red, uint8_t green, uint8_t blue, uint16_t *x, uint16_t *y, bool *trigger, bool *pressed) {
    SPIMaster_select(dev->spi);
    Timer_delay(dev->timer);
    uint8_t x_low  = SPIMaster_send_receive(dev->spi, JSTK_SET_LED_RGB);
    Timer_delay(dev->timer);
    uint8_t x_high = SPIMaster_send_receive(dev->spi, red);
    Timer_delay(dev->timer);
    uint8_t y_low  = SPIMaster_send_receive(dev->spi, green);
    Timer_delay(dev->timer);
    uint8_t y_high = SPIMaster_send_receive(dev->spi, blue);
    Timer_delay(dev->timer);
    uint8_t btns   = SPIMaster_send_receive(dev->spi, 0);
    Timer_delay(dev->timer);
    SPIMaster_deselect(dev->spi);
    Timer_delay(dev->timer);

    *x = (x_high << 8) | x_low;
    *y = (y_high << 8) | y_low;
    *trigger = btns & JSTK_TRIGGER_MASK;
    *pressed = btns & JSTK_PRESSED_MASK;
}

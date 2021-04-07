
#include <Platform/Platform-config.h>
#include "Joystick.h"

#define JSTK_SET_LED_RGB 0x84

#define JSTK_TRIGGER_MASK 2
#define JSTK_PRESSED_MASK 1

void Joystick_init(SPIMaster *dev) {
    SPIMaster_init(dev, 0, 0, CLK_FREQUENCY_HZ / 1000000 - 1);
}

void Joystick_update(SPIMaster *dev, uint8_t red, uint8_t green, uint8_t blue, uint16_t *x, uint16_t *y, bool *trigger, bool *pressed) {
    SPIMaster_select(dev);
    uint8_t x_low  = SPIMaster_send_receive(dev, JSTK_SET_LED_RGB);
    uint8_t x_high = SPIMaster_send_receive(dev, red);
    uint8_t y_low  = SPIMaster_send_receive(dev, green);
    uint8_t y_high = SPIMaster_send_receive(dev, blue);
    uint8_t btns   = SPIMaster_send_receive(dev, 0);
    SPIMaster_deselect(dev);

    *x = (x_high << 8) | x_low;
    *y = (y_high << 8) | y_low;
    *trigger = btns & JSTK_TRIGGER_MASK;
    *pressed = btns & JSTK_PRESSED_MASK;
}

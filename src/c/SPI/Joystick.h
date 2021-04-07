
#ifndef JOYSTICK_H_
#define JOYSTICK_H_

#include "SPI.h"
#include <Timer/Timer.h>

typedef struct {
    SPIMaster *spi;
    Timer *timer;
} Joystick;

void Joystick_init(Joystick *dev);

void Joystick_update(Joystick *dev, uint8_t red, uint8_t green, uint8_t blue, uint16_t *x, uint16_t *y, bool *trigger, bool *pressed);

#endif

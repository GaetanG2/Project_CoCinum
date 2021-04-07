
#ifndef JOYSTICK_H_
#define JOYSTICK_H_

#include "SPI.h"

void Joystick_init(SPIMaster *dev);

void Joystick_update(SPIMaster *dev, uint8_t red, uint8_t green, uint8_t blue, uint16_t *x, uint16_t *y, bool *trigger, bool *pressed);

#endif

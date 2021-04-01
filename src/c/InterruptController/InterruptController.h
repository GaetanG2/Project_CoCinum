
#ifndef INTERRUPT_CONTROLLER_H_
#define INTERRUPT_CONTROLLER_H_

#include <stdint.h>
#include <stdbool.h>

typedef struct {
    uint32_t mask;
    volatile uint32_t events;
} InterruptController;

void InterruptController_enable(InterruptController *dev, uint32_t mask);
void InterruptController_disable(InterruptController *dev, uint32_t mask);
bool InterruptController_has_events(InterruptController *dev, uint32_t mask);
void InterruptController_clear_events(InterruptController *dev, uint32_t mask);

#endif

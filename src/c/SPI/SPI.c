
#include "SPI.h"

void SPIMaster_init(SPIMaster *dev, bool polarity, bool phase, uint8_t timer_max) {
    InterruptController_disable(dev->intc, dev->evt_mask);
    InterruptController_clear_events(dev->intc, dev->evt_mask);

    uint8_t control = 0;
    if (polarity) {
        control |= POLARITY_MASK;
    }
    if (phase) {
        control |= PHASE_MASK;
    }

    *dev->control   = control;
    *dev->timer_max = timer_max;
}

void SPIMaster_select(SPIMaster *dev) {
    *dev->control |= CS_MASK;
}

void SPIMaster_deselect(SPIMaster *dev) {
    *dev->control &= ~CS_MASK;
}

uint8_t SPIMaster_send_receive(SPIMaster *dev, uint8_t data) {
    *dev->data = data;
    while (!InterruptController_has_events(dev->intc, dev->evt_mask));
    InterruptController_clear_events(dev->intc, dev->evt_mask);
    return *dev->data;
}

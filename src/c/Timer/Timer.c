
#include "Timer.h"

void Timer_init(Timer *dev) {
    InterruptController_disable(dev->intc, dev->evt_mask);
    InterruptController_clear_events(dev->intc, dev->evt_mask);
    *dev->limit = 0;
}

void Timer_set_limit(Timer *dev, uint32_t limit) {
    *dev->limit = limit;
}

void Timer_delay(Timer *dev) {
    Timer_clear_event(dev);
    *dev->count = 0;
    while (!Timer_has_events(dev));
    Timer_clear_event(dev);
}

void Timer_enable_interrupts(Timer* dev) {
    InterruptController_enable(dev->intc, dev->evt_mask);
}

void Timer_disable_interrupts(Timer* dev) {
    InterruptController_disable(dev->intc, dev->evt_mask);
}

bool Timer_has_events(Timer *dev) {
    return InterruptController_has_events(dev->intc, dev->evt_mask);
}

void Timer_clear_event(Timer *dev) {
    InterruptController_clear_events(dev->intc, dev->evt_mask);
}

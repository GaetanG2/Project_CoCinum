
#ifndef TIMER_H_
#define TIMER_H_

#include <InterruptController/InterruptController.h>

typedef struct {
    InterruptController *intc;
    uint32_t evt_mask;
    volatile uint32_t *limit;
    volatile uint32_t *count;
} Timer;

void Timer_init(Timer *dev);
void Timer_set_limit(Timer *dev, uint32_t limit);
void Timer_irq_enable(Timer* dev);
void Timer_irq_disable(Timer* dev);
bool Timer_has_event(Timer *dev);
void Timer_clear_event(Timer *dev);

#endif


#ifndef TIMER_H_
#define TIMER_H_

#include <InterruptController/InterruptController.h>

enum {
    TIMER_LIMIT_REG,
    TIMER_COUNT_REG
} TimerRegs;

typedef struct {
    InterruptController *intc;
    uint32_t evt_mask;
    volatile uint32_t *limit;
    volatile uint32_t *count;
} Timer;

void Timer_init(Timer *dev);
void Timer_set_limit(Timer *dev, uint32_t limit);
void Timer_enable_interrupts(Timer* dev);
void Timer_disable_interrupts(Timer* dev);
bool Timer_has_events(Timer *dev);
void Timer_clear_event(Timer *dev);
void Timer_delay(Timer *dev);

#endif

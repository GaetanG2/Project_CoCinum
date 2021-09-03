
#ifndef GPIO_H_
#define GPIO_H_

#include <InterruptController/InterruptController.h>

enum {
    GPIO_INPUT_REG,
    GPIO_OUTPUT_REG
} GPIORegs;

typedef struct {
    InterruptController *intc;
    uint32_t evt_mask;
    InterruptController *intc_on;
    uint32_t on_evt_mask;
    InterruptController *intc_off;
    uint32_t off_evt_mask;
    volatile uint32_t *inputs;
    uint32_t *outputs;
} GPIO;

void GPIO_init(GPIO *dev);
void GPIO_enable_interrupts(GPIO *dev);
void GPIO_disable_interrupts(GPIO *dev);
bool GPIO_has_events(GPIO *dev);
void GPIO_clear_events(GPIO *dev);
uint32_t GPIO_get_on_events(GPIO *dev);
uint32_t GPIO_get_off_events(GPIO *dev);
uint32_t GPIO_get_inputs(GPIO *dev);
uint32_t GPIO_get_outputs(GPIO *dev);
uint32_t GPIO_set_outputs(GPIO *dev, uint32_t value);

#endif

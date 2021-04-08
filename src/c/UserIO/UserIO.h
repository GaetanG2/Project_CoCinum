
#ifndef USER_IO_H_
#define USER_IO_H_

#include <InterruptController/InterruptController.h>

typedef uint32_t UserOutputs;

typedef struct {
    InterruptController *intc;
    InterruptController *intc_on;
    InterruptController *intc_off;
    uint32_t on_evt_mask;
    uint32_t off_evt_mask;
    uint32_t on_off_mask;
    volatile uint32_t *status;
} UserInputs;

void UserInputs_init(UserInputs *dev);
void UserInputs_enable_interrupts(UserInputs *dev);
void UserInputs_disable_interrupts(UserInputs *dev);
bool UserInputs_has_events(UserInputs *dev);
void UserInputs_clear_events(UserInputs *dev);
uint32_t UserInputs_get_on_events(UserInputs *dev);
uint32_t UserInputs_get_off_events(UserInputs *dev);

#endif

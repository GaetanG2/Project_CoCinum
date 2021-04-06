
#ifndef USER_IO_H_
#define USER_IO_H_

typedef uint32_t UserOutputs;

typedef struct {
    InterruptController *intc;
    uint32_t evt_mask;
    volatile uint32_t *status;
    volatile uint32_t *on_evt;
    volatile uint32_t *off_evt;
} UserInputs;

void UserInput_init(UserInputs *dev);
void UserInputs_irq_enable(UserInputs *dev);
void UserInputs_irq_disable(UserInputs *dev);
bool UserInputs_has_event(UserInputs *dev);
void UserInputs_clear_event(UserInputs *dev);

#endif

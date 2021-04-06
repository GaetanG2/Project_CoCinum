
#include "UserIO.h"

void UserInput_init(UserInputs *dev) {
    InterruptController_disable(dev->intc, dev->evt_mask);
    InterruptController_clear_events(dev->intc, dev->evt_mask);
}

void UserInputs_irq_enable(UserInputs *dev) {
    InterruptController_enable(dev->intc, dev->evt_mask);
}

void UserInputs_irq_disable(UserInputs *dev) {
    InterruptController_disable(dev->intc, dev->evt_mask);
}

bool UserInputs_has_event(UserInputs *dev) {
    return InterruptController_has_events(dev->intc, dev->evt_mask);
}

void UserInputs_clear_event(UserInputs *dev) {
    InterruptController_clear_events(dev->intc, dev->evt_mask);
    *dev->on_evt  = -1;
    *dev->off_evt = -1;
}

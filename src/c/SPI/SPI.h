
#ifndef SPI_H_
#define SPI_H_

#include <InterruptController/InterruptController.h>

enum {
    SPI_DATA_REG,
    SPI_CONTROL_REG,
    SPI_TIMER_MAX_REG
} SPIMasterRegs;

typedef struct {
    InterruptController *intc;
    uint32_t evt_mask;
    volatile uint8_t *data;
    uint8_t *control;
    uint8_t *timer_max;
} SPIMaster;

#define POLARITY_MASK 4
#define PHASE_MASK    2
#define CS_MASK       1

void SPIMaster_init(SPIMaster *dev, bool polarity, bool phase, uint8_t timer_max);
void SPIMaster_select(SPIMaster *dev);
void SPIMaster_deselect(SPIMaster *dev);
uint8_t SPIMaster_send_receive(SPIMaster *dev, uint8_t data);

#endif

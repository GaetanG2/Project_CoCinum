
#ifndef I2C_H_
#define I2C_H_

#include <InterruptController/InterruptController.h>

enum {
    I2C_DATA_REG,
    I2C_CONTROL_REG
} I2CMasterRegs;

typedef struct {
    InterruptController *intc;
    uint32_t evt_mask;
    volatile uint32_t *data;
    uint32_t *control;
} I2CMaster;

void I2CMaster_init(I2CMaster *dev);
void I2CMaster_send_receive(I2CMaster *dev, uint8_t slave_address, uint8_t send_len, uint8_t recv_len, uint8_t *data);

typedef struct {
    I2CMaster * i2c;
    uint8_t slave_address;
} I2CDevice;

void I2CDevice_init(I2CDevice *dev);
void I2CDevice_send_receive(I2CDevice *dev, uint8_t send_len, uint8_t recv_len, uint8_t *data);

#endif

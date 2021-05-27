
#include "I2C.h"

void I2CMaster_init(I2CMaster *dev) {
    InterruptController_disable(dev->intc, dev->evt_mask);
    InterruptController_clear_events(dev->intc, dev->evt_mask);
}

void I2CMaster_send_receive(I2CMaster *dev, uint8_t slave_address, uint8_t send_len, uint8_t recv_len, uint8_t *data) {
    *dev->control = ((uint32_t)send_len << 12) | ((uint32_t)recv_len << 8) | slave_address;

    uint32_t buf = 0;
    for (int n = 0; n < 4; n ++) {
        if (n < send_len) {
            buf |= data[n];
        }
        buf <<= 8;
    }
    *dev->data = buf;

    while (!InterruptController_has_events(dev->intc, dev->evt_mask));
    InterruptController_clear_events(dev->intc, dev->evt_mask);

    buf = *dev->data;
    for (int n = 3; n >= 0; n --) {
        if (n < recv_len) {
            data[n] = buf & 0xFF;
        }
        buf >>= 8;
    }
}

void I2CDevice_init(I2CDevice *dev) {
    I2CMaster_init(dev->i2c);
}

void I2CDevice_send_receive(I2CDevice *dev, uint8_t send_len, uint8_t recv_len, uint8_t *data) {
    I2CMaster_send_receive(dev->i2c, dev->slave_address, send_len, recv_len, data);
}

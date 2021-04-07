
#include <Platform/Platform-config.h>
#include "Accelerometer.h"

void Accelerometer_init(SPIMaster *dev) {
    SPIMaster_init(dev, 0, 0, CLK_FREQUENCY_HZ / 2000000 - 1);
}

#ifndef PLATFORM_H_
#define PLATFORM_H_

#include <InterruptController/InterruptController.h>
#include <UART/UART.h>
#include <Timer/Timer.h>

#define CLK_FREQUENCY_HZ     100000000

extern InterruptController *const intc;
extern UART                *const uart;
extern Timer               *const timer;

#endif

#include <SPI/SPI.h>

extern Timer     *const spi_timer;
extern SPIMaster *const spi_master;

#include <SPI/OLED.h>

extern SPIDevice *const spi_dev;
extern OLED *const oled;

#include <SPI/Joystick.h>

extern SPIDevice *const jstk;

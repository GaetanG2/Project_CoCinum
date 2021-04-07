
#ifndef PLATFORM_H_
#define PLATFORM_H_

#include <Platform/Platform-config.h>
#include <InterruptController/InterruptController.h>
#include <UART/UART.h>
#include <Timer/Timer.h>
#include <SegmentDisplay/SegmentDisplay.h>
#include <UserIO/UserIO.h>
#include <SPI/SPI.h>
#include <SPI/Joystick.h>

extern InterruptController *const intc;
extern UART                *const uart;
extern Timer               *const timer1;
extern Timer               *const timer2;
extern Timer               *const timer3;
extern SegmentDisplay      *const display;
extern UserOutputs         *const leds;
extern UserInputs          *const btns;
extern InterruptController *const btns_on;
extern InterruptController *const btns_off;
extern SPIMaster           *const spi1;
extern SPIMaster           *const spi2;
extern Joystick            *const jstk;
#endif

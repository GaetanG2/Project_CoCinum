
#ifndef PLATFORM_H_
#define PLATFORM_H_

#include <InterruptController/InterruptController.h>
#include <UART/UART.h>
#include <Timer/Timer.h>
#include <SegmentDisplay/SegmentDisplay.h>
#include <UserIO/UserIO.h>

#define CLK_FREQUENCY_HZ 100000000

extern InterruptController *const intc;
extern UART                *const uart;
extern Timer               *const timer;
extern SegmentDisplay      *const display;
extern UserOutputs         *const leds;

#endif

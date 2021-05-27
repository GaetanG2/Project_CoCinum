
#ifndef PLATFORM_H_
#define PLATFORM_H_

#include <InterruptController/InterruptController.h>
#include <UART/UART.h>
#include <Timer/Timer.h>
#include <SegmentDisplay/SegmentDisplay.h>
#include <UserIO/UserIO.h>
#include <SPI/SPI.h>
#include <SPI/Joystick.h>
#include <SPI/Accelerometer.h>

#define CLK_FREQUENCY_HZ 100000000

#define INTC_ADDRESS     0x81000000
#define UART_ADDRESS     0x82000000
#define TIMER1_ADDRESS   0x83000000
#define TIMER2_ADDRESS   0x84000000
#define TIMER3_ADDRESS   0x85000000
#define DISPLAY_ADDRESS  0x86000000
#define LEDS_ADDRESS     0x87000000
#define BTNS_ADDRESS     0x88000000
#define BTNS_ON_ADDRESS  0x89000000
#define BTNS_OFF_ADDRESS 0x8A000000
#define SPI1_ADDRESS     0x8B000000
#define SPI2_ADDRESS     0x8C000000

#define BTNS_ON_OFF_MASK 0x000FFFFF

#define INTC_EVENTS_UART_RX  0x0001
#define INTC_EVENTS_UART_TX  0x0002
#define INTC_EVENTS_TIMER1   0x0004
#define INTC_EVENTS_TIMER2   0x0008
#define INTC_EVENTS_TIMER3   0x0010
#define INTC_EVENTS_BTNS_ON  0x0020
#define INTC_EVENTS_BTNS_OFF 0x0040
#define INTC_EVENTS_SPI1     0x0080
#define INTC_EVENTS_SPI2     0x0100

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
extern SPIDevice           *const jstk;
extern SPIDevice           *const acl;

#endif


#include "Platform.h"
#include "Platform-config.h"

InterruptController *const intc = (InterruptController*)INTC_ADDRESS;

static UART uart_priv = {
    .intc        = intc,
    .rx_evt_mask = INTC_EVENTS_UART_RX,
    .tx_evt_mask = INTC_EVENTS_UART_TX,
    .data        = (uint8_t*)UART_ADDRESS
};

UART *const uart = &uart_priv;

static Timer timer_priv = {
    .intc     = intc,
    .evt_mask = INTC_EVENTS_TIMER,
    .limit    = (uint32_t*)TIMER_ADDRESS,
    .count    = (uint32_t*)TIMER_ADDRESS + 1
};

Timer *const timer = &timer_priv;

SegmentDisplay *const display = (SegmentDisplay*)DISPLAY_ADDRESS;

UserOutputs *const leds = (UserOutputs*)LEDS_ADDRESS;

static UserInputs btns_priv = {
    .intc         = intc,
    .intc_on      = (InterruptController*)BTNS_ON_ADDRESS,
    .intc_off     = (InterruptController*)BTNS_OFF_ADDRESS,
    .on_evt_mask  = INTC_EVENTS_BTNS_ON,
    .off_evt_mask = INTC_EVENTS_BTNS_OFF,
    .on_off_mask  = BTNS_ON_OFF_MASK,
    .status       = (uint32_t*)BTNS_ADDRESS,
};

UserInputs *const btns = &btns_priv;

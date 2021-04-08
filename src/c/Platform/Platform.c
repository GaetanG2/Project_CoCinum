
#include "Platform.h"
#include "Platform-config.h"

#define REG(T, ADDR, N) (T*)(ADDR + 4 * N)

/* -------------------------------------------------------------------------- *
 * Global interrupt controller
 * -------------------------------------------------------------------------- */

InterruptController *const intc = (InterruptController*)INTC_ADDRESS;

/* -------------------------------------------------------------------------- *
 * UART
 * -------------------------------------------------------------------------- */

static UART uart_priv = {
    .intc        = intc,
    .rx_evt_mask = INTC_EVENTS_UART_RX,
    .tx_evt_mask = INTC_EVENTS_UART_TX,
    .data        = REG(uint8_t, UART_ADDRESS, 0)
};

UART *const uart = &uart_priv;

/* -------------------------------------------------------------------------- *
 * Timers
 * -------------------------------------------------------------------------- */

static Timer timer1_priv = {
    .intc     = intc,
    .evt_mask = INTC_EVENTS_TIMER1,
    .limit    = REG(uint32_t, TIMER1_ADDRESS, TIMER_LIMIT_REG),
    .count    = REG(uint32_t, TIMER1_ADDRESS, TIMER_COUNT_REG)
};

Timer *const timer1 = &timer1_priv;

static Timer timer2_priv = {
    .intc     = intc,
    .evt_mask = INTC_EVENTS_TIMER2,
    .limit    = REG(uint32_t, TIMER2_ADDRESS, TIMER_LIMIT_REG),
    .count    = REG(uint32_t, TIMER2_ADDRESS, TIMER_COUNT_REG)
};

Timer *const timer2 = &timer2_priv;

static Timer timer3_priv = {
    .intc     = intc,
    .evt_mask = INTC_EVENTS_TIMER3,
    .limit    = REG(uint32_t, TIMER3_ADDRESS, TIMER_LIMIT_REG),
    .count    = REG(uint32_t, TIMER3_ADDRESS, TIMER_COUNT_REG)
};

Timer *const timer3 = &timer3_priv;

/* -------------------------------------------------------------------------- *
 * Segment display
 * -------------------------------------------------------------------------- */

SegmentDisplay *const display = (SegmentDisplay*)DISPLAY_ADDRESS;

/* -------------------------------------------------------------------------- *
 * User I/O
 * -------------------------------------------------------------------------- */

UserOutputs *const leds = (UserOutputs*)LEDS_ADDRESS;

static UserInputs btns_priv = {
    .intc         = intc,
    .intc_on      = (InterruptController*)BTNS_ON_ADDRESS,
    .intc_off     = (InterruptController*)BTNS_OFF_ADDRESS,
    .on_evt_mask  = INTC_EVENTS_BTNS_ON,
    .off_evt_mask = INTC_EVENTS_BTNS_OFF,
    .on_off_mask  = BTNS_ON_OFF_MASK,
    .status       = REG(uint32_t, BTNS_ADDRESS, 0)
};

UserInputs *const btns = &btns_priv;

/* -------------------------------------------------------------------------- *
 * SPI
 * -------------------------------------------------------------------------- */

static SPIMaster spi1_priv = {
    .intc      = intc,
    .evt_mask  = INTC_EVENTS_SPI1,
    .data      = REG(uint8_t, SPI1_ADDRESS, SPI_DATA_REG),
    .control   = REG(uint8_t, SPI1_ADDRESS, SPI_CONTROL_REG),
    .timer_max = REG(uint8_t, SPI1_ADDRESS, SPI_TIMER_MAX_REG)
};

SPIMaster *const spi1 = &spi1_priv;

static SPIMaster spi2_priv = {
    .intc      = intc,
    .evt_mask  = INTC_EVENTS_SPI2,
    .data      = REG(uint8_t, SPI2_ADDRESS, SPI_DATA_REG),
    .control   = REG(uint8_t, SPI2_ADDRESS, SPI_CONTROL_REG),
    .timer_max = REG(uint8_t, SPI2_ADDRESS, SPI_TIMER_MAX_REG)
};

SPIMaster *const spi2 = &spi2_priv;

/* -------------------------------------------------------------------------- *
 * Joystick and accelerometer
 * -------------------------------------------------------------------------- */

static SPIDevice jstk_priv = {
    .spi            = spi1,
    .timer          = timer1,
    .polarity       = 0,
    .phase          = 0,
    .cycles_per_bit = CLK_FREQUENCY_HZ / 1000000, // 1 Mbit/sec
    .cycles_per_gap = CLK_FREQUENCY_HZ / 25000    // 40us (> 25 us)
};

SPIDevice *const jstk = &jstk_priv;

static SPIDevice acl_priv = {
    .spi            = spi2,
    .timer          = timer2,
    .polarity       = 0,
    .phase          = 0,
    .cycles_per_bit = CLK_FREQUENCY_HZ / 2000000, // 2 Mbit/sec
    .cycles_per_gap = CLK_FREQUENCY_HZ / 5000000  // 200ns (> 100 ns)
};

SPIDevice *const acl = &acl_priv;

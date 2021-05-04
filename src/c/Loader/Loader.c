
#include <InterruptController/InterruptController.h>
#include <UART/UART.h>
#include "Platform.h"

// Defined in virgule.ld
extern uint32_t __boot_start, __boot_end;
extern void (*__finalizer)(void);

#define PROGRAM         ((uint8_t*)0)
#define BOOT_START_ADDR ((uint32_t)&__boot_start)

#define FINALIZER_START ((uint32_t)&__finalizer)
#define FINALIZER_END   (FINALIZER_START + sizeof(__finalizer))

static uint8_t get_hex_digit(UART *dev) {
    char c = UART_getc(dev);
    if (c >= '0' && c <= '9') {
        return c - '0';
    }
    if (c >= 'a' && c <= 'f') {
        return c - ('a' - 10);
    }
    if (c >= 'A' && c <= 'F') {
        return c - ('A' - 10);
    }
    return 0;
}

static inline uint8_t get_hex_u8(UART *dev) {
    return (get_hex_digit(dev) << 4) + get_hex_digit(dev);
}

static inline uint16_t get_hex_u16(UART *dev) {
    return (get_hex_u8(dev) << 8) + get_hex_u8(dev);
}

__attribute__((noreturn))
static void receive(void) {
    InterruptController *const intc = (InterruptController*)INTC_ADDRESS;

    InterruptController_disable(intc, -1);
    InterruptController_clear_events(intc, -1);

    // We use a local instance of UART to avoid overwriting it while loading.
    UART uart = {
        .intc        = intc,
        .rx_evt_mask = INTC_EVENTS_UART_RX,
        .tx_evt_mask = INTC_EVENTS_UART_TX,
        .data        = (uint8_t*)UART_ADDRESS
    };

    UART_init(&uart);
    UART_puts(&uart, "\\\\// This is the Virgule program loader. Please send an hex file to execute...\n");

    // Read, analyze and copy a .hex file to memory.
    while (true) {
        // Read the record start character ':'.
        uint8_t c;
        do {
            c = UART_getc(&uart);
        } while (c != ':');

        // Read the number of bytes in the current record.
        uint8_t count = get_hex_u8(&uart);

        // Read the record address.
        uint16_t addr = get_hex_u16(&uart);

        // Read the record type.
        uint8_t rtype = get_hex_u8(&uart);

        // Read the data bytes.
        for (int i = 0; i < count; i ++, addr ++) {
            c = get_hex_u8(&uart);
            if (rtype == 0 && addr < BOOT_START_ADDR && !(addr >= FINALIZER_START && addr < FINALIZER_END)) {
                PROGRAM[addr] = c;
            }
        }

        // Read the checksum.
        get_hex_u8(&uart);

        // Record type 1 signals the end of the file.
        if (rtype == 1) {
            break;
        }
    }

    UART_puts(&uart, "\\\\// Starting user program...\n");

    InterruptController_clear_events(intc, -1);

    // We cannot return from here since the return address is located in a
    // region that has been overwritten. We jump directly to address 0.
    // The user program will take care to initialize the stack again.
    asm("jr zero");
    __builtin_unreachable();
}

__attribute__((noreturn))
void main(void) {
    // Copy this program to the 'boot' region of the memory.
    uint32_t *src = 0;
    uint32_t *dest = &__boot_start;
    uint32_t *dest_end = &__boot_end;
    while (dest < dest_end) {
        *dest ++ = *src ++;
    }

    // Branch to the copy of the receive function in the 'boot' region.
    // Set the variable __finalizer to the same address so that it is executed
    // again when returning from the user's 'main' function.
    __finalizer = receive + BOOT_START_ADDR;
    __finalizer();
    __builtin_unreachable();
}


#include <InterruptController/InterruptController.h>
#include <UART/UART.h>
#include <Platform/Platform-config.h>

// Defined in virgule.ld
extern uint32_t __boot_start, __boot_end, __finalizer;

#define PROGRAM ((uint8_t*)0)
#define BOOT_START_ADDR ((uint32_t)&__boot_start)

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

void receive(void) {
    InterruptController *const intc = (InterruptController*)INTC_ADDRESS;

    InterruptController_disable(intc, -1);
    InterruptController_clear_events(intc, -1);

    // We don't use the global variable 'uart' from Platform.c
    // because it may be overwritten while loading.
    UART uart = {
        .intc        = intc,
        .rx_irq_mask = UART_RX_IRQ_MASK,
        .tx_irq_mask = UART_TX_IRQ_MASK,
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
            if (rtype == 0 && addr < BOOT_START_ADDR) {
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

    // Set the variable __finalizer of the user program to the adress of this
    // 'receive' function (translated to the end of the memory) so that it is
    // executed again when returning from the user's 'main' function.
    __finalizer = (uint32_t)((uint8_t*)receive + BOOT_START_ADDR);

    UART_puts(&uart, "\\\\// Starting user program...\n");

    InterruptController_clear_events(intc, -1);

    // We cannot return from here since the return address is located in a
    // region that has been overwritten. We jump directly to address 0.
    // The user program will take care to initialize the stack again.
    asm("jr zero");
}

void main(void) {
    // Copy this program to the 'boot' region of the memory.
    uint32_t *src = 0;
    uint32_t *dest = &__boot_start;
    uint32_t *dest_end = &__boot_end;
    while (dest < dest_end) {
        *dest ++ = *src ++;
    }

    // Branch to the copy of this program in the 'boot' region.
    asm(
        "auipc t1, 0\n"
        "addi t1, t1, 20\n"
        "add t1, t1, %0\n"
        "add gp, gp, %0\n"
        "jr t1\n"
        :
        : "r" (&__boot_start)
        : "t1", "gp"
    );

    receive();
}

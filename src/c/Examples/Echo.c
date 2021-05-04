
#include "Platform.h"

__attribute__((interrupt("machine")))
void irq_handler(void) {
    UART_irq_handler(uart);
}

void main(void) {
    // Initialiser le pilote de l'interface série.
    UART_init(uart);
    // Envoyer un message de début.
    UART_puts(uart, "Echo> ");
    // Afficher chaque caractère reçu jusqu'à ce que l'utilisateur presse <Entrée>
    char c;
    do {
    	c = UART_getc(uart);
    	UART_putc(uart, c);
    } while (c != '\r');
    // Envoyer un message de fin.
    UART_puts(uart, "Bye!\n");
}

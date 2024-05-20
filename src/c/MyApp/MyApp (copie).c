#include "Platform.h"

static volatile unsigned tick;

__attribute__((interrupt("machine")))
void irq_handler(void) {
    // Appeler le gestionnaire d'interruptions du pilote de l'interface série.
    UART_irq_handler(uart);

    // Incrémenter le compteur tick à chaque interruption du timer.
    if (Timer_has_events(timer)) {
        Timer_clear_event(timer);
        tick ++;
    }
}

void main(void) {
    // Initialiser le pilote de l'interface série
    // et afficher un message de bienvenue.
    UART_init(uart);
    UART_puts(uart, "Joystick Demo.\n");

    // Configurer le timer pour demander des interruptions
    // dix fois par seconde.
    Timer_init(timer);
    Timer_set_limit(timer, CLK_FREQUENCY_HZ / 10);
    Timer_enable_interrupts(timer);

    // Initialiser le contrôleur SPI et le pilote du joystick.
    Joystick_init(jstk);

    JoystickState jstk_state;

    tick = 0;
    unsigned tock = 0;

    // Exécuter jusqu'à ce que l'utilisateur presse une touche.
    while (!UART_has_data(uart)) {
        // Si une ou plusieurs interruptions du timer ont été détectées.
        if (tick != tock) {
            // Configurer la couleur de la LED du joystick.
            jstk_state.red   = 255;
            jstk_state.green = 255;
            jstk_state.blue  = 255;

            // Mettre à jour la couleur de la LED du joystick,
            // lire les coordonnées du joystick et l'état des boutons.
            Joystick_update(jstk, &jstk_state);

            // Ici, vous pouvez utiliser les champs suivants :
            // jstk_state.x       : la coordonnée X du joystick (0 à 1023)
            // jstk_state.y       : la coordonnée Y du joystick (0 à 1023)
            // jstk_state.trigger : vaut 1 si l'utilisateur presse la gachette
            // jstk_state.pressed : vaut 1 si l'utilisateur presse la manette

            tock ++;
        }
    }
}

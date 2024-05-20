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

// Définir des couleurs {Rouge, Vert, Bleu}.
#define B {0,  0,  0}
#define C {31, 31, 0}
#define W {31, 31, 31}
#define R {31,  0,  0}
#define V {0, 31, 0}

#define black   0x0000
#define blue    0x001F
#define red     0xF800
#define green   0x07E0
#define cyan    0x07FF
#define magenta 0xF81F
#define yellow  0xFFE0
#define white   0xFFFF

#define RECT_WIDTH   96
#define RECT_HEIGHT  64

/*
// Définir la taille de l'objet à afficher.
#define SPRITE_WIDTH  7
#define SPRITE_HEIGHT 16
#define SPRITE_SIZE_PIX   (SPRITE_WIDTH * SPRITE_HEIGHT)
#define SPRITE_SIZE_BYTES (SPRITE_SIZE_PIX * 2)

// L'image, représentée par un tableau de couleurs.
static const OLEDColor sprite[SPRITE_SIZE_PIX] = {
    B, B, W, W, W, B, B,
    B, C, W, W, W, W, B,
    C, C, W, W, W, W, W,
    C, C, C, W, W, W, W,
    C, C, C, C, W, W, W,
    B, C, C, C, C, C, B,
    B, B, C, C, C, B, B,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
    R, R, V, V, V, BL, BL,
};
// Tableau qui recevra l'image compactée.
static uint8_t bitmap[SPRITE_SIZE_BYTES];
*/




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
    // Initialiser le contrôleur SPI et le pilote de l'afficheur.
    OLED_init(oled);
    
    
    JoystickState jstk_state;
    
    
    tick = 0;
    unsigned tock = 0;
    
    
    // Définir les coordonnées initiales du rect1.
    uint8_t x1 = 0;
    uint8_t y1 = 0;
    uint8_t x2 = RECT_WIDTH/2;
    uint8_t y2 = RECT_HEIGHT/2;
    
    // Définir les coordonnées initiales du rect2.
    uint8_t x3 = x2;
    uint8_t y3 = y1;
    uint8_t x4 = RECT_WIDTH;
    uint8_t y4 = y2;
    
    // Définir les coordonnées initiales du rect3.
    uint8_t x5 = x1;
    uint8_t y5 = y2;
    uint8_t x6 = x2;
    uint8_t y6 = RECT_HEIGHT;
    
    // Définir les coordonnées initiales du rect3.
    uint8_t x7 = x2;
    uint8_t y7 = y2;
    uint8_t x8 = x4;
    uint8_t y8 = y6;
    
    bool gauche = false;
    bool droite = false;
    bool haut = false;
    bool bas = false;
    
    /*
    // Encoder le sprite, puis l'afficher.
    OLED_set_bitmap(bitmap, SPRITE_SIZE_PIX, sprite);
    OLED_draw_bitmap(oled, x1, y1, x2, y2, SPRITE_SIZE_BYTES, bitmap);
    */
    
    OLEDColor greenColor = {0, 31, 0};
    OLEDColor redColor = {31, 0, 0};
    OLEDColor yellowColor = {31, 31, 0};
    OLEDColor blueColor = {0, 0, 31};
    OLEDColor blackColor = {0, 0, 0};
    
    OLED_fill_rect(oled, x1, y1, x2, y2, greenColor, greenColor);
    OLED_fill_rect(oled, x3, y3, x4 - 1, y4, redColor, redColor);
    OLED_fill_rect(oled, x5, y5, x6 - 1, y6 - 1, yellowColor, yellowColor);
    OLED_fill_rect(oled, x7, y7, x8 - 1, y8 - 1, blueColor, blueColor);

    // Exécuter jusqu'à ce que l'utilisateur presse une touche.
    while (!UART_has_data(uart)) {
        // Si une ou plusieurs interruptions du timer ont été détectées.
        if (tick != tock) {
            /*
            // Configurer la couleur de la LED du joystick.
            jstk_state.red   = 255;
            jstk_state.green = 255;
            jstk_state.blue  = 255;
            */

            // Mettre à jour la couleur de la LED du joystick,
            // lire les coordonnées du joystick et l'état des boutons.
            Joystick_update(jstk, &jstk_state);
            
            if (jstk_state.x < 300) {
            	bas = true;
            } else if (jstk_state.x > 700) {
        	haut = true;
            } else {
            	bas = false;
            	haut = false;
            }
            	

	    if (jstk_state.y < 300) {
            	droite = false;
            } else if (jstk_state.y > 700) {
            	gauche = true;
            } else {
            	gauche = false;
            	droite = false;
            }
            
            if (haut == true && gauche == true) {
        	UART_puts(uart, "Vert.\n");
            }
            if (haut == true && droite == true) {
        	UART_puts(uart, "Rouge.\n");
            }
            if (bas == true && droite == true) {
        	UART_puts(uart, "Bleu.\n");
            }
            if (bas == true && gauche == true) {
        	UART_puts(uart, "Jaune.\n");
            }

            // Ici, vous pouvez utiliser les champs suivants :
            // jstk_state.x       : la coordonnée X du joystick (0 à 1023)
            // jstk_state.y       : la coordonnée Y du joystick (0 à 1023)
            // jstk_state.trigger : vaut 1 si l'utilisateur presse la gachette
            // jstk_state.pressed : vaut 1 si l'utilisateur presse la manette

            tock ++;
        }
    }
}

#include "print.h"



void kernel_main() {
    print_clear();

    uint8_t bg_color = 0;
    uint8_t fg_color = 0;
    for(uint8_t i = 0; i < 10; i++){
        print_set_color(WHITE, BLACK);
        bg_color = (bg_color + 1) % 16;
        fg_color = (fg_color + 2) % 16;
        print_set_color(fg_color, bg_color);
        print_str(" OBAMA DIALUP ");
    }
}
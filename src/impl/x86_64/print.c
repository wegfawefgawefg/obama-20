#include "print.h"

const static size_t NUM_COLS = 80;
const static size_t NUM_ROWS = 25;

struct Char {
    uint8_t character;
    uint8_t color;
};

struct Char* buffer = (struct Char*) 0xb8000;
size_t x = 0;
size_t y = 0;
uint8_t color = WHITE | BLACK << 4;


void clear_row(size_t y) {
    struct Char empty = (struct Char) {
        character: ' ',
        color: color,
    };

    for (size_t x = 0; x < NUM_COLS; x++) {
        buffer[x + y * NUM_COLS] = empty;
    }
}

void print_clear() {
    for (size_t y = 0; y < NUM_ROWS; y++) {
        clear_row(y);
    }
}

void shift_rows_up() {
    x = 0;

    if (y < NUM_ROWS - 1) {
        y++;
        return;
    }

    for (size_t y = 1; y < NUM_ROWS; y++) {
        for (size_t x = 0; x < NUM_COLS; x++) {
            struct Char character = buffer[x + y * NUM_COLS];
            buffer[x + NUM_COLS * (y - 1)] = character;
        }
    }

    clear_row(NUM_COLS - 1);
}

void print_char(char character) {
    if (character == '\n') {
        shift_rows_up();
        return;
    }

    //  word wrap
    if (x > NUM_COLS) {
        shift_rows_up();
    }

    buffer[x + y * NUM_COLS] = (struct Char) {
        character: (uint8_t) character,
        color: color,
    };

    x++;
}

void print_str(char* str) {
    for (size_t i = 0; 1; i++) {
        char character = (uint8_t) str[i];

        if (character == '\0') {
            return;
        }

        print_char(character);
    }
}

void print_set_color(uint8_t foreground, uint8_t background) {
    color = foreground + (background << 4);
}
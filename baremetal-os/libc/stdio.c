/* =============================================================================
 * NanoOS Standard C Library - stdio
 * =============================================================================
 */

#include <stdint.h>

/* VGA text mode */
#define VGA_BASE 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static uint16_t* vga_buffer = (uint16_t*)VGA_BASE;
static int cursor_x = 0;
static int cursor_y = 0;

/* Print character to screen */
void print_char(char c) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if (c == '\r') {
        cursor_x = 0;
    } else if (c == '\b') {
        if (cursor_x > 0) {
            cursor_x--;
            vga_buffer[cursor_y * VGA_WIDTH + cursor_x] = 0x0F00 | ' ';
        }
    } else {
        vga_buffer[cursor_y * VGA_WIDTH + cursor_x] = 0x0F00 | c;
        cursor_x++;
    }
    
    if (cursor_x >= VGA_WIDTH) {
        cursor_x = 0;
        cursor_y++;
    }
    
    if (cursor_y >= VGA_HEIGHT) {
        /* Scroll screen */
        int i;
        for (i = 0; i < (VGA_HEIGHT - 1) * VGA_WIDTH; i++) {
            vga_buffer[i] = vga_buffer[i + VGA_WIDTH];
        }
        /* Clear last line */
        for (i = (VGA_HEIGHT - 1) * VGA_WIDTH; i < VGA_HEIGHT * VGA_WIDTH; i++) {
            vga_buffer[i] = 0x0F00 | ' ';
        }
        cursor_y = VGA_HEIGHT - 1;
    }
}

/* Print string */
void print(const char* str) {
    while (*str) {
        print_char(*str++);
    }
}

/* Print integer */
void print_int(int num) {
    char buffer[32];
    int i = 0;
    int is_negative = 0;
    
    if (num < 0) {
        is_negative = 1;
        num = -num;
    }
    
    if (num == 0) {
        buffer[i++] = '0';
    } else {
        while (num > 0) {
            buffer[i++] = '0' + (num % 10);
            num /= 10;
        }
    }
    
    if (is_negative) {
        print_char('-');
    }
    
    /* Reverse and print */
    for (int j = i - 1; j >= 0; j--) {
        print_char(buffer[j]);
    }
}

/* Print hex */
void print_hex(unsigned int num) {
    char buffer[16];
    int i = 0;
    
    if (num == 0) {
        print("0x0");
        return;
    }
    
    while (num > 0) {
        int digit = num % 16;
        if (digit < 10) {
            buffer[i++] = '0' + digit;
        } else {
            buffer[i++] = 'A' + (digit - 10);
        }
        num /= 16;
    }
    
    print("0x");
    for (int j = i - 1; j >= 0; j--) {
        print_char(buffer[j]);
    }
}

/* Clear screen */
void clear_screen(void) {
    int i;
    for (i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = 0x0F00 | ' ';
    }
    cursor_x = 0;
    cursor_y = 0;
}

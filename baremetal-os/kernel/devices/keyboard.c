/* =============================================================================
 * Keyboard Driver
 * =============================================================================
 */

#include <kernel.h>

#define KEYBOARD_DATA_PORT 0x60
#define KEYBOARD_STATUS_PORT 0x64

/* Keyboard buffer */
#define KB_BUFFER_SIZE 256
static char keyboard_buffer[KB_BUFFER_SIZE];
static int buffer_head = 0;
static int buffer_tail = 0;

/* Key codes */
#define KEY_ENTER 0x1C
#define KEY_BACKSPACE 0x0E
#define KEY_LSHIFT 0x2A
#define KEY_RSHIFT 0x36
#define KEY_SHIFT 0x80

static int shift_pressed = 0;

/* Scancode to ASCII lookup table */
static const char scancode_to_ascii[] = {
    0, 0, '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
    '-', '=', '\b', '\t', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i',
    'o', 'p', '[', ']', '\n', 0, 'a', 's', 'd', 'f', 'g', 'h', 'j',
    'k', 'l', ';', '\'', '`', 0, '\\', 'z', 'x', 'c', 'v', 'b', 'n',
    'm', ',', '.', '/', 0, 0, 0, ' '
};

static const char scancode_shift[] = {
    0, 0, '!', '@', '#', '$', '%', '^', '&', '*', '(', ')',
    '_', '+', '\b', '\t', 'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I',
    'O', 'P', '{', '}', '\n', 0, 'A', 'S', 'D', 'F', 'G', 'H', 'J',
    'K', 'L', ':', '"', '~', 0, '|', 'Z', 'X', 'C', 'V', 'B', 'N',
    'M', '<', '>', '?', 0, 0, 0, ' '
};

/* Keyboard interrupt handler */
extern void keyboard_handler(void);

void keyboard_init(void) {
    buffer_head = 0;
    buffer_tail = 0;
    shift_pressed = 0;
    
    /* Remap keyboard interrupt (IRQ1) */
    /* In real implementation, this would set up the IDT entry */
}

/* Handle keyboard interrupt */
void keyboard_handler_main(void) {
    uint8_t scancode = inb(KEYBOARD_DATA_PORT);
    
    /* Handle shift keys */
    if (scancode == KEY_LSHIFT || scancode == KEY_RSHIFT) {
        shift_pressed = 1;
        return;
    }
    if (scancode == (KEY_LSHIFT | KEY_SHIFT) || scancode == (KEY_RSHIFT | KEY_SHIFT)) {
        shift_pressed = 0;
        return;
    }
    
    /* Only handle key press (bit 7 = 0) */
    if (scancode & 0x80) {
        return;
    }
    
    /* Get ASCII character */
    char c;
    if (shift_pressed) {
        c = scancode_shift[scancode];
    } else {
        c = scancode_to_ascii[scancode];
    }
    
    /* Add to buffer if not empty */
    if (c != 0) {
        int next_head = (buffer_head + 1) % KB_BUFFER_SIZE;
        if (next_head != buffer_tail) {
            keyboard_buffer[buffer_head] = c;
            buffer_head = next_head;
        }
    }
}

/* Read a character from keyboard buffer */
char keyboard_read(void) {
    while (buffer_head == buffer_tail) {
        __asm__ volatile ("hlt");
    }
    
    char c = keyboard_buffer[buffer_tail];
    buffer_tail = (buffer_tail + 1) % KB_BUFFER_SIZE;
    return c;
}

/* Check if keyboard buffer has data */
int keyboard_available(void) {
    return buffer_head != buffer_tail;
}

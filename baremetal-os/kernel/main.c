/* =============================================================================
 * NanoOS Kernel - Main Entry Point
 * =============================================================================
 */

#include <kernel.h>
#include <gdt.h>
#include <idt.h>
#include <memory.h>
#include <vfs.h>

/* VGA text mode */
#define VGA_BASE 0xB8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static unsigned short* vga_buffer = (unsigned short*)VGA_BASE;
static int cursor_x = 0;
static int cursor_y = 0;

/* Kernel color */
#define KERNEL_COLOR 0x0F

/* Print character to screen */
void putchar(char c) {
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if (c == '\r') {
        cursor_x = 0;
    } else {
        vga_buffer[cursor_y * VGA_WIDTH + cursor_x] = (KERNEL_COLOR << 8) | c;
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
            vga_buffer[i] = (KERNEL_COLOR << 8) | ' ';
        }
        cursor_y = VGA_HEIGHT - 1;
    }
}

/* Print string */
void print(const char* str) {
    while (*str) {
        putchar(*str++);
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
        putchar('-');
    }
    
    /* Reverse the buffer */
    for (int j = i - 1; j >= 0; j--) {
        putchar(buffer[j]);
    }
}

/* Kernel main */
void kernel_main(void) {
    /* Initialize GDT */
    gdt_init();
    
    /* Initialize IDT */
    idt_init();
    
    /* Initialize memory management */
    memory_init();
    
    /* Initialize VFS */
    vfs_init();
    
    /* Clear screen */
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
        vga_buffer[i] = (KERNEL_COLOR << 8) | ' ';
    }
    cursor_x = 0;
    cursor_y = 0;
    
    /* Banner */
    print("========================================\n");
    print("        Welcome to NanoOS v0.1          \n");
    print("   A Simple OS Built from Scratch      \n");
    print("========================================\n\n");
    
    /* System info */
    print("System initialized successfully!\n");
    print("Memory: ");
    print_int(get_total_memory());
    print(" KB\n");
    print("\nNanoOS> ");
    
    /* Halt - in real implementation, this would start the shell */
    while (1) {
        __asm__ volatile ("hlt");
    }
}

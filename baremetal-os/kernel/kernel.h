/* =============================================================================
 * NanoOS Kernel Header
 * =============================================================================
 */

#ifndef KERNEL_H
#define KERNEL_H

/* Basic types */
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

/* Boolean */
#define true 1
#define false 0
typedef int bool;

/* Port I/O */
static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

static inline uint8_t inb(uint16_t port) {
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

/* Halt */
static inline void hlt(void) {
    __asm__ volatile ("hlt");
}

/* Interrupt enable/disable */
static inline void sti(void) {
    __asm__ volatile ("sti");
}

static inline void cli(void) {
    __asm__ volatile ("cli");
}

/* Memory barrier */
static inline void mb(void) {
    __asm__ volatile ("" : : : "memory");
}

/* Functions */
void gdt_init(void);
void idt_init(void);
void memory_init(void);
uint32_t get_total_memory(void);
void vfs_init(void);

#endif /* KERNEL_H */

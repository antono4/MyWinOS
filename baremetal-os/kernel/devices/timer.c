/* =============================================================================
 * Timer Driver (PIT - Programmable Interval Timer)
 * =============================================================================
 */

#include <kernel.h>

#define PIT_CHANNEL0 0x40
#define PIT_COMMAND 0x43

/* Timer frequency */
#define TIMER_FREQ 100  /* 100 Hz */
#define TIMER_DIVISOR 1193182 / TIMER_FREQ

/* Timer tick counter */
static volatile uint32_t tick_count = 0;

/* Get tick count */
uint32_t timer_ticks(void) {
    return tick_count;
}

/* Initialize PIT */
void timer_init(void) {
    /* Send command to PIT */
    outb(PIT_COMMAND, 0x36);
    
    /* Set divisor (low byte first, then high byte) */
    outb(PIT_CHANNEL0, TIMER_DIVISOR & 0xFF);
    outb(PIT_CHANNEL0, (TIMER_DIVISOR >> 8) & 0xFF);
    
    tick_count = 0;
}

/* Timer interrupt handler */
extern void timer_handler(void);

void timer_handler_main(void) {
    tick_count++;
}

/* Sleep for specified milliseconds */
void sleep(uint32_t ms) {
    uint32_t start = tick_count;
    uint32_t target = start + (ms * TIMER_FREQ / 1000);
    
    while (tick_count < target) {
        __asm__ volatile ("hlt");
    }
}

/* Get uptime in seconds */
uint32_t uptime_seconds(void) {
    return tick_count / TIMER_FREQ;
}

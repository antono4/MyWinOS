/* =============================================================================
 * Memory Management
 * =============================================================================
 */

#include <kernel.h>

/* Physical memory information */
static uint32_t total_memory = 0;

/* Simple physical memory allocator */
#define PAGE_SIZE 4096
#define MAX_PAGES 1024

typedef struct page {
    uint32_t address;
    int used;
} page_t;

static page_t pages[MAX_PAGES];
static int page_count = 0;

/* Initialize memory management */
void memory_init(void) {
    /* Detect memory using BIOS int 0x15, function 0xE820 */
    /* For simplicity, we'll assume 32MB of RAM */
    total_memory = 32 * 1024;  /* 32 MB in KB */
    
    /* Initialize page allocator */
    page_count = (total_memory * 1024) / PAGE_SIZE;
    if (page_count > MAX_PAGES) {
        page_count = MAX_PAGES;
    }
    
    for (int i = 0; i < page_count; i++) {
        pages[i].address = i * PAGE_SIZE;
        pages[i].used = 0;
    }
}

/* Allocate a page of physical memory */
void* kmalloc(void) {
    for (int i = 0; i < page_count; i++) {
        if (!pages[i].used) {
            pages[i].used = 1;
            return (void*)pages[i].address;
        }
    }
    return 0;  /* No memory available */
}

/* Free a page */
void kfree(void* ptr) {
    uint32_t addr = (uint32_t)ptr;
    int page_index = addr / PAGE_SIZE;
    
    if (page_index < page_count) {
        pages[page_index].used = 0;
    }
}

/* Get total memory in KB */
uint32_t get_total_memory(void) {
    return total_memory;
}

/* Get free memory in KB */
uint32_t get_free_memory(void) {
    uint32_t free_pages = 0;
    for (int i = 0; i < page_count; i++) {
        if (!pages[i].used) {
            free_pages++;
        }
    }
    return (free_pages * PAGE_SIZE) / 1024;
}

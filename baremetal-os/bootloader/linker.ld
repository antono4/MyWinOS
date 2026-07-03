/* =============================================================================
 * NanoOS Linker Script
 * =============================================================================
 * Defines memory layout for the kernel
 */

OUTPUT_FORMAT("elf32-i386")
ENTRY(_start)

SECTIONS
{
    . = 0x10000;  /* Kernel loads at 1MB */
    
    .text : {
        *(.boot)
        *(.text)
        *(.rodata)
    }
    
    .data : {
        *(.data)
    }
    
    .bss : {
        *(.bss)
    }
    
    /DISCARD/ : {
        *(.comment)
        *(.eh_frame)
    }
}

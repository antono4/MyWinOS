; =============================================================================
; NanoOS Bootloader - Stage 2
; =============================================================================
; Stage 2 bootloader: Switches to protected mode and loads kernel
; Uses GRUB multiboot specification

.code16
.section .boot

.global stage2_start
stage2_start:
    ; Set up GDT
    cli
    lgdt gdt_descriptor
    
    ; Enable A20 line
    inb $0x92, %al
    or %al, 2
    outb %al, $0x92
    
    ; Switch to protected mode
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0
    
    ; Far jump to set CS
    ljmp $0x08, $0x10000

.align 16
gdt_start:
    ; Null descriptor
    .quad 0x0000000000000000
    
    ; Code segment descriptor
    .word 0xFFFF      ; Limit
    .word 0x0000      ; Base (low)
    .byte 0x00        ; Base (middle)
    .byte 0x9A        ; Access byte (present, ring 0, code, readable)
    .byte 0xCF        ; Flags (4K gran, 32-bit, limit hi)
    .byte 0x00        ; Base (high)
    
    ; Data segment descriptor
    .word 0xFFFF      ; Limit
    .word 0x0000      ; Base (low)
    .byte 0x00        ; Base (middle)
    .byte 0x92        ; Access byte (present, ring 0, data, writable)
    .byte 0xCF        ; Flags (4K gran, 32-bit, limit hi)
    .byte 0x00        ; Base (high)
gdt_end:

gdt_descriptor:
    .word gdt_end - gdt_start - 1
    .long gdt_start

; Protected mode entry point
.code32
.section .pmode

.global protected_start
protected_start:
    ; Set up segment registers
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    
    ; Set up stack
    movl $0x90000, %esp
    
    ; Print message
    movl $msg_loaded, %esi
    call print_pm
    
    ; Jump to kernel (placeholder)
    jmp kernel_start

print_pm:
    lodsb
    test %al, %al
    jz done_pm
    movb $0x0E, %ah
    int $0x10
    jmp print_pm
done_pm:
    ret

kernel_start:
    hlt
    jmp kernel_start

msg_loaded:
    .asciz "\r\nNanoOS Stage 2: Protected Mode Enabled\r\n"

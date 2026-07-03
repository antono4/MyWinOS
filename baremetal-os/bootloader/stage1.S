; =============================================================================
; NanoOS Bootloader - Stage 1 (MBR)
; =============================================================================
; Stage 1 bootloader: Loads stage 2 from disk and jumps to it
; Uses BIOS interrupts for disk access

.code16
.section .boot

.global _start
_start:
    ; Save drive number
    movb %dl, drive_num
    
    ; Set up segments
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw %ax, %es
    
    ; Set stack
    movw $0x7C00, %sp
    
    ; Clear screen
    movb $0x03, %ah
    int $0x10
    
    ; Print loading message
    movw $msg_loading, %si
    call print_string
    
    ; Load stage 2 (15 sectors = 7680 bytes)
    movw $0x1000, %ax
    movw %ax, %es
    xorw %bx, %bx
    
    movb $0x02, %ah          ; Function: read sectors
    movb $0x0E, %al          ; Sector count (14 sectors for stage2 + bootinfo)
    movb $0x02, %ch          ; Cylinder 0
    movb $0x01, %cl          ; Start from sector 2
    movb drive_num, %dl      ; Drive number
    xorw %dh, %dh            ; Head 0
    int $0x13
    jc disk_error
    
    ; Jump to stage 2
    jmp 0x0000:0x1000

disk_error:
    movw $msg_error, %si
    call print_string
    jmp hang

print_string:
    lodsb
    or %al, %al
    jz done
    movb $0x0E, %ah
    int $0x10
    jmp print_string
done:
    ret

hang:
    jmp hang

drive_num:
    .byte 0

msg_loading:
    .asciz "NanoOS: Loading...\r\n"
msg_error:
    .asciz "Disk read error!\r\n"

; Padding and boot signature
.fill 510 - (. - _start)
.word 0xAA55

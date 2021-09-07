gdt_start:; need these labels because they compute the sizes and the jumps
    dd 0x0; ; start with 2x4 null bytes
    dd 0x0;

;gdt for code segment, base =x00000000, length = 0xfffff
; flags = os-dev.pdf pg 36
gdt_code:
    dw 0xffff; segment length, bits 0-15
    dw 0x0; segment base 0-15
    dw 0x0; segment base 16-23
    db 10011010b; flags (8 bites)
    db 11001111b; flags(4 bits) + segment len, bits 16-19
    db 0x0

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0


gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1; size 16 bits, always one less of the actual size
    dd gdt_start; address (32 bit)

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

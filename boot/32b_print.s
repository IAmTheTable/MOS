[bits 32]; using 32bit protec mode

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0F; the color byte for the chars

print_string_pm:
    pusha
    mov edx, VIDEO_MEMORY

print_string_pm_loop:
    mov al, [ebx]; the base address of the char
    mov ah, WHITE_ON_BLACK
    
    cmp al, 0; check if its the end of the string
    je print_string_pm_done

    mov [edx], ax; store char + attr
    add ebx, 1; next char
    add edx, 2; next video mem pos, in bytes, since the char is only 2

    jmp print_string_pm_loop

print_string_pm_done:
    popa
    ret
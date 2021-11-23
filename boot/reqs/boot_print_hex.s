print_hex:
    pusha ; save registers to the stack
    
    mov cx, 0; our index

hex_loop:
    cmp cx, 4; loop 4 times
    je end

    mov ax, dx
    and ax, 0x000F; 0x1234 -> 0x0004, masks the first 3 to zeros
    
    add al, 0x30; add 0x30 to N to convert it to ascii N
    cmp al, 0x39; if > 9 add an extra 8 to represent A-F
    
    jle step2
    add al, 7

step2:
    mov bx, HEX_OUT + 5; base + len
    sub bx, cx; subtract by our current index
    
    mov [bx], al
    ror dx, 4; 0x1234 -> 4123 -> 3412 -> 2341 -> 1234

    add cx, 1
    jmp hex_loop

end:
    mov bx, HEX_OUT
    call print
    
    popa
    ret

HEX_OUT:
    db '0x0000', 0; reserve for the string
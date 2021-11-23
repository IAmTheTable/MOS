print:
    pusha

start:
    mov al, [bx] ;return base address for the string because we pass the ptr of it
    cmp al, 0 ; check if its 0
    je done

    mov ah, 0xE
    int 10h

    add bx, 1
    jmp start

done:
    popa
    ret

print_nl:
    pusha

    mov ah, 0xE
    mov al, 0xA

    int 0x10

    mov al, 0xD
    int 0x10
    
    popa
    ret


; load dh sectors from drive dl into ES:BX
disk_load:
    pusha
    ; since reading uses specific registers we will save them here for now
    push dx

    mov ah, 0x02; on interrupt 0x13, the sub func 2 is read
    mov al, dh; number of sectors to read
    mov cl, 0x02;cl -> sector 0x1 .. 0x11
        ; 0x1 is the boot sec, 0x2 is the first available sector
    mov ch, 0x0; the cylinder 0x0 .. 0x3FF, upper 2 bits in cl
    ;dl -> drive number the caller sets it as a parameter and gets it from the bios
    ; 0 = floppy, 1 = floppy2, 0x80 is hdd, 0x81 = hdd2
    mov dh, 0x00; dh -> head number 0x0 .. 0xF

    ;[ex:bx] ptr to the buffer where the data will be stored
    ; caller sets it up for us, and its actually the std location for the int 13
    int 0x13; call interrupt
    jc disk_error; if error, stored in the carry bit(flag)

    pop dx
    cmp al, dh; bios sets al to the # of sectors read, compare it
    jne sectors_error
    popa; restore the registers
    ret

disk_error:
    mov bx, DISK_ERROR
    call print
    call print_nl
    mov dh, ah; ah = er code, dl = disk drive that called the err
    call print_hex
    jmp disk_loop

sectors_error:
    mov bx, SECTORS_ERROR
    call print
    call print_nl

disk_loop:
    jmp $

DISK_ERROR: db "BOOT DISC: Disk read error", 0
SECTORS_ERROR: db "Incorrect number of sectors to read", 0
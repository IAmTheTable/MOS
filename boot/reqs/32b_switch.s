[bits 16]
switch_to_pm:
    cli; 1. disable interrtups
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1; 3. set 32 bit more in cr0
    mov cr0, eax
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    mov ax, DATA_SEG
    mov dx, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    call BEGIN_PM
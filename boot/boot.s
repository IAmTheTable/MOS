; global bios offset
[org 0x7c00]
mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print

call switch_to_pm
jmp $

; current address so basically just inf looping
; this is the zero padding and the magic boot number 

%include "boot/boot_print.s"
%include "boot/32b_gdt.s"
%include "boot/32b_print.s"
%include "boot/32b_switch.s"
[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm; written in top left
	jmp $

MSG_REAL_MODE db "Started in 16 bit real mode", 0
MSG_PROT_MODE db "Loaded into 32 bit protected mode", 0

times 510 - ($-$$) db 0
dw 0xaa55 

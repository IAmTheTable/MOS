; global bios offset

[bits 16]
[org 0x7c00]

start:
	cli ; clear interrupts
	xor ax, ax ; 
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, STACK
	mov sp, bp
	jmp 0:main

main:
	sti ; start interrupts

	mov [BOOT_DRV], dl
	call clear_screen

	mov ax, MSG_REAL_MODE
	call print_cstring

	call load_kernel

	call pm_switch

	hlt

; constants
KERNEL_OFFSET equ 0x1000
STACK equ 0x9000

; variables
BOOT_DRV db 0

%include "reqs/boot_print.s"
%include "reqs/32b_gdt.s"
%include "reqs/32b_print.s"
%include "reqs/32b_switch.s"
%include "reqs/clear_scr.s"
%include "reqs/print_cstr.s"
%include "reqs/load_kernel.s"
%include "reqs/load_sectors.s"

[bits 32]
BEGIN_PM:
	mov eax, MSG_PROT_MODE
	call print_string_pm; written in top left
	call KERNEL_OFFSET

	hlt

MSG_REAL_MODE db "Started in 16 bit real mode", 0
MSG_PROT_MODE db "Loaded into 32 bit protected mode", 0

times 510 - ($-$$) db 0
dw 0xaa55 

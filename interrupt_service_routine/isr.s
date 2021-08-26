/* filename: isr_wrapper.s */
.globl   isr
.align   4
 
isr:
    pushal
    cld /* C code following the sysV ABI requires DF to be clear on function entry */
    call on_interrupt_hit
    popal
    iret

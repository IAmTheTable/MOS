#include "../drivers/terminal.hpp"
#include <stddef.h>
#include <stdbool.h>

struct IDTDescr {
   uint16_t offset_1; // offset bits 0..15
   uint16_t selector; // a code segment selector in GDT or LDT
   uint8_t zero;      // unused, set to 0
   uint8_t type_attr; // type and attributes, see below
   uint16_t offset_2; // offset bits 16..31
};

struct interrupt_frame
{
    uint16_t ip;
    uint16_t cs;
    uint16_t flags;
    uint16_t sp;
    uint16_t ss;
};

__attribute__((interrupt)) void on_interrupt_hit(struct interrupt_frame* frame);

__attribute__((interrupt)) void on_interrupt_hit(struct interrupt_frame* frame)
{
    /* do something */
    terminal_writestring("Interrupt hit!");
}
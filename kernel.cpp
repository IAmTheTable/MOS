#include "drivers/terminal.hpp"
/* Check if the compiler thinks you are targeting the wrong operating system. */
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif
 
/* This tutorial will only work for the 32-bit ix86 targets. */
#if !defined(__i386__)
#error "This needs to be compiled with a ix86-elf compiler"
#endif
 
extern "C" void t_w(int scan_code, int charac)
{
	terminal_writestring("Scan code: ");
	terminal_writestring(reinterpret_cast<const char*>(scan_code));
	terminal_writestring("\n");
	terminal_writestring("Char code: ");
	terminal_writestring(reinterpret_cast<const char*>(charac));
	terminal_writestring("\n");
}
 
extern "C" void kernel_main(void) 
{
	/* Initialize terminal interface */
	terminal_initialize();
 
	/* Newline support is left as an exercise. */
	terminal_writestring("First line\n");
	terminal_writestring("Second line(yes i need to fix the random character)\n");
	terminal_writestring_c("This text is cyan!\n", vga_color::VGA_COLOR_CYAN);
	terminal_writestring("This is very ");
	terminal_writestring_c("bad", vga_color::VGA_COLOR_RED);

}   


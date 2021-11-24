#include "kernel.hpp"
#include "../drivers/terminal.hpp"
#include "../drivers/kbd.hpp"
#include "../drivers/pic.hpp"
#include "../drivers/pit.hpp"
#include "../drivers/utils.hpp"
#include "../drivers/interrupts.hpp"

#include "os_main.hpp"

static INPUT_HNDLR input_f = default_input;

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
	
	idt_init(IDT);				// set id table
	pic_initialize();			// intialize the pic
	set_interval_size(1000);	// count every 1000 ticks
	pit_initialize(1000);		// start timer ticking every ms
	kbd_initialize();			// enable keyboard

	__asm__("sti"); 			// enable interrupts
	
	terminal_writestring("INTERRUPTS ENABLED");
	os_main_entry();
	while(true)
	{
		halt();
	}
}   

void kbd_dispatch(int kbd_scan_code)
{
	/* called by the kbd_irq, dispatches the keyboard
	 * input to the function pointed to by input_f */

	 input_f(kbd_scan_code);
}

void set_input_function(INPUT_HNDLR proc_input)
{
	/* with this you can set a custom function
	 * dealing with keyboard input */
	input_f = proc_input;
}

void default_input(int code)
{
	/* default input function does nothing */
	terminal_writestring(reinterpret_cast<const char*>(code));
	return;
}
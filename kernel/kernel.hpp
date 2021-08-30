#include "drivers/terminal.hpp"
#include "drivers/kbd.hpp"
#include "drivers/pic.hpp"
#include "drivers/pit.hpp"
#include "drivers/interrupts.hpp"

typedef void(*INPUT_HNDLR)(int code); /* pointer to keyboard input handler */
void kbd_dispatch(int kbd_scan_code);
void set_input_function(INPUT_HNDLR proc_input);
void default_input(int code);
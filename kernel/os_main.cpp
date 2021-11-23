#include "os_main.hpp"
#include "./kernel.hpp"
#include "../drivers/terminal.hpp"
#include "../drivers/utils.hpp"

void os_main_entry()
{
    set_input_function(on_key_pressed);
    while(true)
    {
        halt();
    }
}

void on_key_pressed(int keycode)
{
    terminal_putchar_c(static_cast<char>(keycode), vga_color::VGA_COLOR_CYAN);
}
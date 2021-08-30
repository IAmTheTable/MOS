
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg);
static inline uint16_t vga_entry(unsigned char uc, uint8_t color);
size_t strlen(const char* str);
void terminal_initialize(void);
void terminal_setcolor(uint8_t color);
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y);
void terminal_putchar(char c);
void terminal_write(const char* data, size_t size);
void terminal_writestring(const char* data);

/* Hardware text mode color constants. */
 
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg) 
{
	return fg | bg << 4;
}
 
static inline uint16_t vga_entry(unsigned char uc, uint8_t color) 
{
	return (uint16_t) uc | (uint16_t) color << 8;
}
 
size_t strlen(const char* str) 
{
	auto len = 0;
	while (str[len])
		len++;
	return len;
}
 
static constexpr auto VGA_WIDTH = 80;
static constexpr auto VGA_HEIGHT = 25;
 
size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color = 0;
uint16_t* terminal_buffer;
 
void terminal_initialize(void) 
{
	terminal_row = 0;
	terminal_column = 0;
	terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
	terminal_buffer = reinterpret_cast<uint16_t*>(0xB8000);
	for (auto y = 0; y < VGA_HEIGHT; y++) {
		for (auto x = 0; x < VGA_WIDTH; x++) {
			const auto index = y * VGA_WIDTH + x;
			terminal_buffer[index] = vga_entry(' ', terminal_color);
		}
	}
}
 
void terminal_setcolor(vga_color text_color, vga_color background_color = vga_color::VGA_COLOR_BLACK) 
{
	terminal_color = vga_entry_color(text_color, background_color);
}
 
void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) 
{
	const auto index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}
 
void terminal_putchar(char c) 
{
	terminal_putentryat(c, terminal_color, terminal_column, terminal_row);
	if (++terminal_column == VGA_WIDTH) {
		terminal_column = 0;
		if (++terminal_row == VGA_HEIGHT)
			terminal_row = 0;
	}
}
 
void terminal_write(const char* data, size_t size) 
{
	// subtracting one for null terminator
	for (auto i = 0; i < size; i++)
	{
       switch(data[i])
       {
           case '\n':
                terminal_column = 0;
                terminal_row++;
				break;
            default:
			{
				if(static_cast<int>(data[i]) >= 32 && static_cast<int>(data[i]) <= 126)
					terminal_putchar(data[i]);
				else
					i++;
				break;
			}
       }
    }
}

void terminal_writestring(const char* data) 
{
	terminal_write(data, strlen(data));
}
void terminal_writestring_c(const char* data, vga_color color)
{
	auto color_backup = terminal_color;
	terminal_setcolor(color);
	terminal_writestring(data);
	terminal_color = color_backup;
}
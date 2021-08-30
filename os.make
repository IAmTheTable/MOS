# generate list of c sources
C_SOURCES = $(wildcard drivers/*.cpp kernel/*.cpp)

# generate list of headers
HEADERS = $(wildcard drivers/*.hpp kernel/*.hpp)

# convert .c to .o
OBJ = ${C_SOURCES:.c=.o}

# $^ - all dependencies
# $< - the first dependency
# $@ - the target file

%.o : %.c ${HEADERS} 
	/mnt/c/Users/Administrator/Desktop/opt/gcc/bin/i686-elf-g++ -masm=intel -c $< -o $@ -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

MOS.bin: kernel/kernel.o ${OBJ}
	/mnt/c/Users/Administrator/Desktop/opt/gcc/bin/i686-elf-g++ -masm=intel -T linker.ld -o MOS.bin -ffreestanding -O2 -nostdlib $^ -lgcc
boot.o: boot.s
	/mnt/c/Users/Administrator/Desktop/opt/gcc/bin/i686-elf-as $< -o $@
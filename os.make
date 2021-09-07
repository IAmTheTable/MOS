# generate list of c sources
C_SOURCES = $(wildcard kernel/*.cpp drivers/*.cpp)

# generate list of headers
HEADERS = $(wildcard kernel/*.hpp drivers/*.hpp)

ASM = $(wildcard *.s)

# convert .c to .o
OBJ = ${C_SOURCES:.cpp=.o}

# $^ - all dependencies
# $< - the first dependency
# $@ - the target file



%.o : %.cpp ${HEADERS}
	echo $<
	/mnt/c/Users/Administrator/Desktop/opt/gcc/bin/i686-elf-g++ -c $< -o $@ -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti

build/MOS.bin: ${OBJ}
	nasm -f coff boot/boot.s -o boot.o
	/mnt/c/Users/Administrator/Desktop/opt/gcc/bin/i686-elf-g++ -T linker.ld -o $@ -ffreestanding -O2 -nostdlib boot.o $^ -lgcc

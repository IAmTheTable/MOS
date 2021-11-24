# generate list of c sources
C_SOURCES = $(wildcard kernel/*.cpp drivers/*.cpp)

# generate list of headers
HEADERS = $(wildcard kernel/*.hpp drivers/*.hpp)

ASM = $(wildcard boot/reqs/*.s)

# convert .c to .o
OBJ = ${C_SOURCES:.cpp=.o}

# $^ - all dependencies
# $< - the first dependency
# $@ - the target file


build/MOS.img: boot/boot.bin build/MOS.bin
	cat $^ > build/MOS.img
	dd if=build/MOS.img of=TableOS.img bs=512 count=2880

%.o : %.cpp ${HEADERS}
	echo $<
	/opt/cross/bin/i686-elf-cpp $< -o $@ -ffreestanding

build/MOS.bin: boot/k_main.o ${OBJ}
	/opt/cross/bin/i686-elf-cpp -ffreestanding $< -o $@ -lgcc

boot/k_main.o: boot/k_main.s
	nasm $< -f elf -o $@

boot/boot.bin: boot/boot.s $(ASM)
	echo $<
	nasm $< -f bin -I 'boot/' -o $@
export desktop="/mnt/c/Users/Administrator/Desktop"
export gcc="$desktop/opt/gcc/bin"
$gcc/i686-elf-as boot.s -o boot.o
echo "assembled the multi boot header"
$gcc/i686-elf-g++ -masm=intel -c kernel.cpp -o kernel.o -ffreestanding -O2 -Wall -Wextra -fno-exceptions -fno-rtti
echo "Compiling kernel"
$gcc/i686-elf-g++ -masm=intel -T linker.ld -o MOS.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc
echo "Linking kernel"
if grub-file --is-x86-multiboot MOS.bin; then
  echo multiboot confirmed
else
  echo the file is not multiboot
fi
echo "Created tmp directories"
mkdir -p tmp/boot/grub
echo "Copying files"
cp MOS.bin ./tmp/boot
cp grub.cfg ./tmp/boot/grub/
echo "Creating the iso"
rm ./build/TableOS.iso
grub-mkrescue -o ./build/TableOS.iso tmp
echo "Deleting temp files"
rm boot.o
rm kernel.o
rm isr_a.o
rm isr.o
rm ./build/MOS.bin
cp MOS.bin ./build/MOS.bin
rm -rf ./tmp
echo "Done"
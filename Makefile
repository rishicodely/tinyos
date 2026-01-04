CC = gcc
LD = ld
CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T kernel/linker.ld -nostdlib

all: kernel.bin

kernel.bin: kernel/kernel.o
	$(LD) $(LDFLAGS) -o kernel.bin kernel/kernel.o

kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c kernel/kernel.c -o kernel/kernel.o

run: kernel.bin
	mkdir -p iso/boot/grub
	cp kernel.bin iso/boot/kernel.bin
	cp boot/grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o os.iso iso
	qemu-system-x86_64 -cdrom os.iso

clean:
	rm -rf kernel/*.o kernel.bin iso os.iso

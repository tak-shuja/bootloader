all:
	nasm -f bin boot.asm -o boot.bin
	dd if=boot.bin of=floppy.img bs=1024 count=1


run: all
	qemu-system-i386 -fda floppy.img

clean:
	rm floppy.img
	rm boot.bin

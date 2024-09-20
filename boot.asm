[BITS 16]
[ORG 0x7C00]

; BIOS stores boot drive in DL, so
; it's best to remember this for later.
mov [BOOT_DISK], dl	
	
jmp start

read_disk:
	pusha
	xor ax, ax
	mov es, ax

	mov ah, 0x02
	mov al, 2
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, [BOOT_DISK]
	int 0x13
	
	popa
	ret


start:

	;welcome_msg printing
	mov bx, hello_msg
	call print_string

	; read the disk
	mov bx, 0x7e00
	mov dh, 2
	call disk_read
	
	mov ah, 0x0e
	mov al, [0x7e00]
	int 0x10

hlt:
	; jump to halt label so the program runs infinitely
	jmp hlt

; external file [stdlib.asm]
%include "utils/stdlib.asm"
; external file [data.asm] (for constants)
%include "utils/data.asm"




; set up padding (fill the remaining file with zeroes)
times 510 - ($- $$)  db 0

; write the magic word in the final two bytes
dw 0xAA55

; BIOS is present in the first sector (512 bytes) so
; any data past it will be stored in the next sectors

; Saving character 'b' in the next sector and
; printing them in order to check if the read
; disk procedure worked
times 512 db 'b'


; PRINT STRING START

; the string buffer will be put in
; the bx register.

print_string:
	; save the content of registers by
	; pushing it onto the stack
	pusha

	; switch to tele-type mode
	; to enable writing to the screen
	mov AH, 0x0E
print_loop:
	; Move the byte at the memory address
	; stored in BX to AL register
	mov al, [bx]

	; compare the value in al with zero
	or al, al
	; if zero, jump to print_end
	jz print_end
	int 0x10
	; else increment the bx register by 1
	inc bx
	; repeat
	jmp print_loop

print_end:
	; retrieve the register contents
	; from the stack
	popa
	; return to the caller
	ret

; PRINT STRING END


; PRINT HEX START

print_hex:
	pusha
	mov cx, 0			; initialize the counter


hex_loop:
	cmp cx, 4			; are we at the end of loop yet?
	je end_hex_loop
	
	; convert dx hex values to ascii
	
	mov ax, dx			; copy data from dx to ax
	and ax, 0x000F		; turn 1st 3 hex bits to 0, keep the final digit to convert


	add al, 0x30		; get ascii number value by default. [0x30 -> 0]
	cmp al, 0x39		; is hex value 0-9 or A-F

	jle move_into_bx	; if 0-9, jump to move into bx
	add al, 0x07		; else add 7 to get ascii 'A' - 'F'

move_into_bx:
	mov bx, hex_string	; base address of hex string + length of string
	sub bx, cx			; subtract loop counter
	mov [bx], al		; 
	ror dx, 4			; rotate right dx by 4 bits

	add cx, 1			; increment cx
	jmp hex_loop		;

end_hex_loop:
	mov bx, hex_string
	call print_string	
	
	popa
	ret


hex_string: db "0x0000"

; PRINT HEX END



; DISK READ START
disk_read:
	pusha
	
	xor ax, ax
	mov es, ax

	mov ah, 0x02		; read_disk
	mov al, dh			; dh -> sectors to read
	mov ch, 0x00		; cylinder 0
	mov cl, 0x02		; sector to start reading from
	mov dh, 0x00		; head 0
						; dl -> BOOT DISK -> IN THE CALLER FILE	
	int 0x13


	; NOW ERROR HANDLING
	
	; if carry flag is set, disk read is not successfull
	; error code -> AH
	jc disk_read_error
	
	; else carry normal execution
	popa
	ret


; DISK READ END



; DISK READ ERROR START
disk_read_error:
	mov bx, DISK_ERROR_MSG
	call print_string
	
	; now print the error code in AH
	mov al, ah
	add al, '0'
	mov ah, 0x0e
	int 0x10
	

	jmp $

DISK_ERROR_MSG db "Disk read error! ERROR_CODE: ", 0x0a, 0x0d, 0x00
; DISK READ ERROR END

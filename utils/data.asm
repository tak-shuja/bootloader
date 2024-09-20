; DATA SECTION
hello_msg: db "Bootloader Program Initialization Complete!", 0x0a, 0x0d, 0x00

read_disk_success_msg: db "If 'b' is printed next, the program works", 0x0a,0x0d, 0x00

debug: db "DEBUG MESSAGE", 0x0a, 0x0d, 0x00

BOOT_DISK: db 0



# Custom Bootloader

## Overview

This project is a custom bootloader written in x86 Assembly. It is designed to load from a disk (legacy BIOS) and perform basic bootloader functionalities such as displaying a welcome message, reading sectors from the disk, and error handling. The bootloader loads and displays data from the next sector to verify the disk read operation.

## Features

- **x86 16-bit real mode**: The bootloader operates in 16-bit real mode for compatibility with legacy BIOS.
- **Disk reading**: Reads data from the disk and prints it to the screen.
- **Error handling**: Detects disk read failures and displays error codes.
- **Custom string and hex print routines**: Provides simple I/O functions for displaying text and hex values.

## File Structure

- **`boot.asm`**: The main bootloader file. It initializes the boot process, prints a welcome message, reads sectors from the disk, and handles errors.
- **`utils/stdlib.asm`**: Contains utility functions for printing strings and hexadecimal values to the screen.
- **`utils/data.asm`**: Stores constants and data such as strings and the boot disk number.
- **`Makefile`**: Build system for compiling the bootloader and running it using QEMU.

## How It Works

1. **Boot Process**: The bootloader starts at memory address `0x7C00` after being loaded by the BIOS. It stores the boot drive information, jumps to the main `start` label, and displays a welcome message.
2. **Disk Read**: It attempts to read from the disk into memory starting from sector 2. The data read from the disk is displayed on the screen.
3. **Error Handling**: If the disk read fails, an error message along with the error code is displayed on the screen.
4. **Utilities**: Utility routines are used to print strings and hexadecimal numbers to the screen.

## Instructions

### Requirements

- **NASM**: The assembler for compiling the bootloader.
- **QEMU**: An emulator for running the bootloader without needing physical hardware.

### Build and Run

1. **Compile the Bootloader**:
   ```bash
   make
   ```

2. **Run in QEMU**:
   ```bash
   make run
   ```

3. **Clean Build Files**:
   ```bash
   make clean
   ```

### Disk Image

The bootloader is compiled into a binary file `boot.bin` and written to `floppy.img`. The bootloader occupies the first 512 bytes (one sector), and additional data is stored in the next sector.

### Error Handling

- If the disk read fails, the bootloader displays:
  ```
  Disk read error! ERROR_CODE: X
  ```
  where `X` is the error code returned by the BIOS interrupt `int 0x13`.

## Code Breakdown

### `boot.asm`

- **Boot Disk Handling**: The boot disk is stored in `BOOT_DISK`, which is retrieved from the BIOS upon boot.
- **Disk Read Routine**: Reads sectors from the disk using the BIOS interrupt `int 0x13`.
- **Error Handling**: If the disk read fails, an error message is displayed using the error code provided by `int 0x13`.
  
### `utils/stdlib.asm`

- **`print_string`**: Displays a null-terminated string from memory to the screen using the BIOS interrupt `int 0x10` in teletype mode.
- **`print_hex`**: Displays a hexadecimal number to the screen (used for error codes).

## Future Improvements

- Implement a file system loader to read files from the disk.
- Support additional BIOS interrupts and hardware functions.
- Transition to 32-bit protected mode for more complex operating system features.


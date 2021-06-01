global long_mode_start
extern kernel_main

section .text
bits 64
long_mode_start:
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; OBAMA 20.0
    ; mov dword [0xb8000], 0x2f422f4f
    ; mov dword [0xb8004], 0x2f4d2f41
    ; mov dword [0xb8008], 0x2f202f41
    ; mov dword [0xb800c], 0x2f302f32
    ; mov dword [0xb8010], 0x2f302f2e

    call kernel_main

    hlt

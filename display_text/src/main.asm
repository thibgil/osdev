org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A
; BIOS: Basic Input Output System

; prints a string to the screen
; Params:
; - ds:si points to string
start: ; make a jump to keep main as the main loop
    jmp main

puts:
    ; save register we will modify
    push si
    push ax

.loop:
    lodsb ; loads the next character in al
    or al, al ; verify if al 
    jz .done

    mov ah, 0x0e
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop ax
    pop si
    ret

main:
    ; setup data segments
    mov ax, 0 ; can't write to ds/es directly
    mov ds, ax
    mov es, ax 

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00 ; stack grows downwards from where we are loaded in memomry

    mov si, msg_helloworld
    call puts

    hlt

.halt:
    jmp .halt

msg_helloworld: db 'Hello World !', ENDL, 0
times 510-($-$$) db 0
dw 0AA55h
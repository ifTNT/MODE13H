org 100h
section .text
    
    ; Go back text mode
    mov ah, 0
    mov al, 3
    int 10h

    ;Return to DOS
    mov ah, 4ch
    int 21h
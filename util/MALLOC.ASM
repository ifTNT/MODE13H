bits 16
org 100h

    mov cx, 100
alloc:
    mov ah, 48h
    mov bx, 4
    int 21h
    loop alloc
    jc not_success
    nop
    mov es, ax
    mov ah, 49h
    int 21h
not_success:
    mov ah, 4ch
    int 21h
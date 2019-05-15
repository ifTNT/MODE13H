bits 16

segment code
    jmp START

    ;Import library
    %include "mode13h.asm"

START:    
    ;Set stack
    mov ax, stack
    mov ss, ax
    mov sp, stack_top

    enterVideoMode
    setDoubleBufMode
    clearScreen

;============
;Initialize
;============
    mov ax, dragon
    mov ds, ax
    mov word [ds:xpos], 10
    mov byte [ds:ypos], 100 

    ;Draw bitmap
    setPos di, [xpos], [ypos]
    mov ax, dragon
    mov ds, ax  ;Segment of bitmap
    mov si, stand ;Head offset of bitmap
    call printBitmap
    
    call flushBuffer

    ;Wait for user input
    mov ah, 00h
    int 16h

;----------------------------    
%define speed 1
    mov cx, 280/speed
    mov ax, walk1
MOVE_CHAR:
    push ax
    clearScreen

    ;Draw bitmap
    setPos di, [ds:xpos], [ds:ypos] ;X,Y
    mov ax, dragon
    mov ds, ax  ;Segment of bitmap
    pop ax
    mov si, ax ;Head offset of bitmap
    call printBitmap

    call flushBuffer

    mov ax, [xpos]
    add ax, speed
    mov [xpos], ax
    test cx, 00000100b
    mov ax, walk1
    jz .next
    mov ax, walk2
.next:
    loop MOVE_CHAR
    
    enterTextMode

    ;Return to DOS
    mov ah, 4ch
    int 21h

segment dragon align=16
    xpos: dw 0
    ypos: db 0
	stand:
        dw 20, 20 ;width, height
		incbin "media/dragon-stand.bin"
    walk1:
        dw 20, 20;width, height
        incbin "media/dragon-walk-1.bin"
    walk2:
        dw 20, 20;width, height
        incbin "media/dragon-walk-2.bin"
        
segment stack stack align=16
    resb 256
    stack_top: 

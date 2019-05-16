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
    mov byte [ds:ypos], 70 

    ;Draw bitmap
    mov ax, dragon
    mov ds, ax  ;Segment of bitmap
    setPos di, [ds:xpos], [ds:ypos]
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
    mov ax, dragon
    mov ds, ax  ;Segment of bitmap
    setPos di, [ds:xpos], [ds:ypos] ;X,Y
    pop ax
    mov si, ax ;Head offset of bitmap
    call printBitmap

    call flushBuffer

    ;Update x position
    mov ax, [ds:xpos]
    mov bx, [ds:xspeed]
    add ax, bx
    mov [ds:xpos], ax

    ;Update y speed
    mov al, [ds:yspeed]
    mov bl, [ds:yacc]
    add al, bl
    mov [ds:yspeed], al

    ;Update y pos
    mov bl, al
    mov al, [ds:ypos]
    add al, bl

    ;Floor detection
;--------
    mov bl, [ds:floor]
    cmp al, bl
    jna setYpos ;If not hit floor

;----
    mov ah, 1
	int 16h ;Get key statue
    jz clearSpeed ;if no key hit
    mov ah, 0
    int 16h ;Clear keyboard buffer
    mov byte [ds:yspeed], -10 ;Do a little jump
    mov al, bl ;Put dragon on floor
    jmp setYpos
clearSpeed:
    mov byte [ds:yspeed], 0
    mov al, bl ;Put dragon on floor
;----

setYpos:
    mov [ds:ypos], al
;--------

    ;Switch animation frame each 4 ticks
    test cx, 00000100b
    mov ax, walk1
    jz .next
    mov ax, walk2
.next:
    dec cx
    jnz MOVE_CHAR
    
    enterTextMode

    ;Return to DOS
    mov ah, 4ch
    int 21h

segment dragon align=16
    xpos: dw 0
    ypos: db 0
    floor: db 100
    xspeed: dw speed
    yspeed: db 0
    yacc: db 2
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

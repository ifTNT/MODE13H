bits 16

%define doubleBuffering 1

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
    setDirectMode
    clearScreen

    mov ax, 0
    mov es, ax

    ;Wait for user input
    mov ah, 00h
    int 16h

%macro colorTest 1
    mov al, %1
    call fillColor
    ;Wait for user input
    mov ah, 00h
    int 16h
%endmacro

    colorTest 40 ;Red
    colorTest 47 ;Green
    colorTest 32 ;Blue

;----------------------------    
%if(doubleBuffering)
    setDoubleBufMode
    clearScreen
    mov ax, 0
    mov es, ax
%endif

    call fillRainbow

    setPos di, 144, 100 ;X,Y
    call printColorBlock

    ;Draw bitmap
    setPos di, 200, 100 ;X,Y
    mov ax, images
    mov ds, ax  ;Segment of bitmap
    mov si, bug ;Head offset of bitmap
    call printBitmap

%if(doubleBuffering)
    call flushBuffer
%endif

    ;Wait for user input
    mov ah, 00h
    int 16h

;----------------------------    
%define speed 1
    mov cx, 300/speed;
    mov bx, 0;
MOVE_CHAR:
    
    clearScreen

    ;Draw bitmap
    setPos di, bx, 100 ;X,Y
    mov ax, images
    mov ds, ax  ;Segment of bitmap
    mov si, bug ;Head offset of bitmap
    call printBitmap

%if(doubleBuffering)
    call flushBuffer
%endif

    add bx, speed
    loop MOVE_CHAR

;----------------------------    
    mov cx, 400;
    mov ax, bug;
    mov bx, bug2;
ANIMATION:
    clearScreen
    push ax

    ;Draw bitmap
    setPos di, 150, 100 ;X,Y
    mov ax, images
    mov ds, ax  ;Segment of bitmap
    pop ax
    mov si, ax ;Head offset of bitmap
    call printBitmap

%if(doubleBuffering)
    call flushBuffer
%endif

    xchg ax,bx
    loop ANIMATION

    enterTextMode

    ;Return to DOS
    mov ah, 4ch
    int 21h


segment images align=16
	bug:
        dw 20, 20 ;width, height
		incbin "media/bug_image.bin"
    bug2:
        dw 20, 20 ;width, height
        incbin "media/bug2_image.bin"

segment stack stack align=16
    resb 256
    stack_top: 
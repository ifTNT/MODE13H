MODE13H
====
A 16-bits DOS assembly graphic library for NASM+DosBox

## Features
- Use VGA video mode
- 320x200 resolution
- 256 colors support
- Support double buffering

## Requirement
- NASM>=2.14.02
- TLINK=2.0 from TASM

## Usage
1. Add `%include "mode13h.asm"` at the second instruction of code segment
2. Put jmp instruction before including for the purpose of jump to your code
3. Use enterVideoMode macro
4. Use setDirectMode or setDoubleBufMode
5. enjoy it :)

## Example
See test/test.asm  
Build it: `make all`

## Author/License
ifTNT @2019 / MIT

## Macros
### enterVideoMode
Action: Switch to VGA video mode(320x200,256 colors)

### enterTextMode
Action: Switch to text mode(80x25)

### setDirectMode
Action: Set to direct output mode  
Exit: es: Segment of frame buffer

### setDoubleBufMode
Action: Set to double buffering mode  
Exit: es: Segment of second frame buffer

### clearScreen
Action: Set all pixel to black

### setPos
Action: Calculate position of 2D coordinate in frame buffer  
Parameters: index register,X,Y  
Exit: index register=flatten position

### nextRow
Action: move index of frame buffer to next row  
Parameters: index register, width  
Exit: index register=new position

## Functions
### flushBuffer
Action: Flush second buffer to frame buffer  
Parameter: es: Segment of second buffer

### fillColor
Action: Set all pixel to specific color  
Parameters: al: Color to set  
Exit: None

### printColorBlock
Action: Print a 32 * 32 color block which each color takes 2 * 2 space  
Parameters:
- es: Segment of frame buffer
- di: Start position
Exit: none

### fillRainbow
Action: Fill all screen with 256 color  
Parameters: es: Segment of frame buffer  
Exit: none

### printBitmap
Action: Print a bitmap with transparent(255=transparent)  
        First two word of bitmap indicate [width, hight]
Parameters:
- es: Segment to frame buffer
- di: Start position
- ds: Segment to bitmap
- si: Offset of head of bitmap
Exit:
- di: End position
- si: End of bitmap



## TODOs
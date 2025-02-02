﻿#defbyte	x
#defbyte	y


main_init:

	LD A, 0x0
	ST #x, A
	LD A, 0x0
	ST #y, A

main_loop:

	LD A, #x
	LD C, #y
	CALL :draw_pixel		

	LD D, A
	CALL :delay
	LD A, D

	INC A
	
	// if (x == 8) x=0
	LD D, 0x8
	LD B, A
	SUB A, D
	LD A, B
	JP Z, :clear_x

	ST #x, A
	JP :main_loop

clear_x:
	// Reset x and clear previous line
	LD A, 0x0
	ST #x, A
	LD C, #y
	OUT 1, A, C		
	LD C, 0x8
	OUT 1, A, C		


	LD A, #y
	INC A
	ST #y, A

	// if (y == 8) y=0
	LD D, 0x8
	SUB A, D
	JP Z, :clear_y

	JP :main_loop

clear_y:
	// Reset y
	LD A, 0x0
	ST #y, A
	JP :main_loop


// Draws a pixel in coord A, C
draw_pixel:

	LD B, 0x1

	LD F, 0x7

dp_loop:

	LD D, A
	SUB A, F
	LD A, D

	JP Z, :dp_end
	
	LD E, B
	ADD B, E

	LD H, F
	DEC H
	LD F, H
	JP :dp_loop

dp_end:

	OUT 1, B, C
	LD D, 0x8
	OUT 1, B, D

	RET



// delay by value in A register
delay:
	DNW A
	JP Z, :de_end
	DEC A
	JP :delay
de_end:
	RET

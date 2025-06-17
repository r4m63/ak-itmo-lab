	.data

stack_pointer:  	.word 0x256
input_addr: 		.word 0x80
output_addr:		.word 0x84

	.text
	.org 0x88

_start:
    movea.l  	stack_pointer, A7
    movea.l  	(A7), A7
	movea.l		input_addr, A0
	movea.l		(A0), A0
	movea.l		output_addr, A1
	movea.l     (A1), A1

	jsr 		is_binary_palindrome

	move.l		D3, (A1)
    halt



is_binary_palindrome:
	link 		A6, 4
	move.l 		(A0), D0	; binary
	move.l      D0, -4(A6)
	move.l 		0, D1		; reversed binary
	move.b 		32, D2 		; loop counter

loop:
	jsr			shift_result_and_add_bit
	lsr.l 		1, D0
	sub.b  		1, D2
	bne 		loop

	move.l 		-4(A6), D0
	xor.l 		D0, D1
	beq			return_one

return_zero:
	move.l 		0, D3
	jmp 		ret

return_one:
	move.l 		1, D3

ret:
	unlk		A6
	rts

shift_result_and_add_bit:
	lsl.l 	  	1, D1
	move.l      D0, D4
	and.b 		1, D4
	add.b		D4, D1
	rts


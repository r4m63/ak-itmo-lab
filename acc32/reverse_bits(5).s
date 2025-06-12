	.data
 
input_addr:    		.word 0x80
output_addr:   		.word 0x84
n:             		.word 0x0
remaining_bits:	   	.word 32
one: 	   			.word 0x1
reverse:		   	.word 0x0
 
	.text
 
_start:
 
	load_ind 		input_addr
	store 			n
 
loop:
 
	load			reverse
	shiftl			one
	store 			reverse
	load 			n
	and				one
	add 			reverse
	store			reverse
 
	load			n
	shiftr			one
	store			n
 
	load			remaining_bits
	sub				one
	beqz 			print_reverse
	store			remaining_bits
 
	jmp 			loop
 
 
print_reverse:
 
	load			reverse
	store_ind 		output_addr
 
    halt

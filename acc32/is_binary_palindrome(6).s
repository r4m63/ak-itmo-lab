	.data
input_addr:			.word 	0x80
output_addr:		.word 	0x84
inverted_binary:	.word   0x0
binary: 			.word   0x0
tmp:				.word 	0x0
one: 				.word   0x1
new_bit: 			.word   0x0
i:					.word   32
zero:				.word   0
 
	.text
 
_start:
	load_ind 		input_addr
	store 			binary
	store			tmp
 
 
loop:
	load			binary
	and				one
	store			new_bit
 
	load 			inverted_binary
	shiftl			one
	add				new_bit
	store			inverted_binary
 
 
	load			binary
	shiftr			one
	store			binary
 
	load			i
	sub				one
	store			i
	bgt				loop
 
	load			tmp
	xor				inverted_binary
	bnez			no_it_is_not
 
yes_it_is:
	load 			one
	jmp 			return_is_binary_palindrome
 
no_it_is_not:
	load			zero
 
return_is_binary_palindrome:
	store_ind 		output_addr
	halt

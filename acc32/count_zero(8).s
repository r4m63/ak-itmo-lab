	.data
input_addr:			.word 	0x80
output_addr:		.word 	0x84
num:				.word   0x0
const_1:			.word   0x1
count: 				.word   0x0
loop_counter:		.word 	32
 
	.text
_start:
	load_ind 		input_addr
	store 			num
 
loop:
	load			num
	and 			const_1
	xor 			const_1
	add				count
	store			count
 
	load			num
	shiftr			const_1
	store			num
 
    load			loop_counter
	sub				const_1
	store			loop_counter
 
	bgt				loop	
 
print_count:
	load			count
	store_ind		output_addr
 
	halt

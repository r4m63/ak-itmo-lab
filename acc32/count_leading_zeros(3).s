	.data
 
number: 			.word 	0
result: 			.word 	0
mask:				.word 	0x80000000
const_1:			.word   1
remaining_bits:		.word 	32
in_addr:			.word 	0x80
out_addr: 			.word 	0x84
 
	.text
 
_start:
	load_ind 		in_addr
	store			number
 
loop:	
	load			number
	and				mask
	bnez			count_end
 
	load			result
	add				const_1
	store			result
 
	load			mask
	shiftr			const_1
	store			mask
 
	load			remaining_bits
	sub				const_1
	beqz			count_end
	store			remaining_bits
 
	jmp				loop	
 
count_end:
	load			result
	store_ind 		out_addr
    halt

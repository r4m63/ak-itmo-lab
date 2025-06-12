	.data
buffer:				.byte '________________________________'
input_addr:    		.word 0x80
output_addr:   		.word 0x84
ptr: 	   	   		.word 0
tmp:		   		.word 0
const_FF:	   		.word 0xFF
const_0:			.word 0
const_1:	       	.word 1
letter_Z_plus_one:	.word 0x5B
letter_A:			.word 0x41
whitespace_symbol: 	.word ' '
letter_a: 			.word 0x61
whitespace_flag: 	.word 0x0
change_size_const:	.word 0x20
new_line_code: 	    .word 10
mask_for_store:		.word 0xFFFFFF00
symbols_limit: 		.word 32
overflow_val: 		.word 0xCCCCCCCC
 
	.text
	.org 	0x88
 
_start:
	load_imm		buffer
	store	 		ptr	
 
read_input:	
	load_ind		input_addr
	and				const_FF
 
	store			tmp
	xor				new_line_code
	beqz			put_zero_symbol
 
check_prev_symbol:
	load 			whitespace_flag
	bnez 			make_small_if_capital
 
make_capital_if_small:
	load			tmp
	sub				letter_a
	ble 			store_letter
	load			tmp
	sub				change_size_const
	store			tmp
 
store_letter:
	load_ind		ptr
	and 			mask_for_store
	add				tmp
	store_ind		ptr
 
	load    		ptr
	add				const_1
	store			ptr
 
	and				const_FF
	xor				symbols_limit
	beqz			return_overflow
 
	load			tmp
	and				const_FF
	xor 			whitespace_symbol
	store			whitespace_flag
 
	jmp				read_input
 
make_small_if_capital:
	load 			tmp
	sub				letter_A
	ble				store_letter
	load			tmp
	sub				letter_Z_plus_one
	beqz			store_letter
	bgt				store_letter
	load			tmp
	add				change_size_const
	store			tmp
	jmp				store_letter
 
put_zero_symbol:
	load_ind		ptr
	and				mask_for_store
	store_ind		ptr
 
print_buffer:
	load_imm		buffer
	store			ptr
 
while_buffer:
	load_ind		ptr
	and 			const_FF
	beqz			end
	store_ind		output_addr
 
	load    		ptr
	add				const_1
	store			ptr
 
	jmp 			while_buffer
 
return_overflow:
	load     		overflow_val
	store_ind		output_addr
 
end:
	halt

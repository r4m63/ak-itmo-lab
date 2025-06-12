	.data
 
len: 	   			.byte 7
buffer:	       		.byte 'Hello, ________________________'
question:      		.byte 19, 'What is your name?\n'
byte_mask:	   		.word 0xFF
const_1:	       	.word 1
const_10: 	       	.word 10
length_limit:       .word 30
mask_to_put_byte:   .word 0xFFFF_FF00
exclamation_mark: 	.word '!'
loop_counter: 	   	.word 0
pointer: 	   	   	.word 0
tmp:		   		.word 0
input_addr:    		.word 0x80
output_addr:   		.word 0x84
 
	.text
    .org    0x88
 
_start:
 
print_question:
	load_imm		question
	store 			pointer
 
	load_ind 		pointer
	and 			byte_mask
    store			loop_counter
 
	load			pointer
	add				const_1
	store			pointer
 
	load			loop_counter
 
while_1:
	beqz 			read_input
 
	load_ind		pointer
	and 			byte_mask
	store_ind		output_addr
 
	load			pointer
	add				const_1
	store			pointer
 
	load			loop_counter
	sub				const_1
	store			loop_counter
 
	jmp 			while_1
 
read_input:
	load_imm		buffer
	add				len
    and             byte_mask
	store 			pointer	
 
while_2:	
	load_ind		input_addr
	and				byte_mask
 
	store			tmp
	xor				const_10
	beqz			store_exclamation_mark
 
	load_ind		pointer
	and             mask_to_put_byte
	add				tmp
	store_ind		pointer
 
	load			len
	add				const_1
	store			len
    and             byte_mask
    sub             length_limit
    beqz            overflow
 
	load			pointer
	add				const_1
	store			pointer
 
	jmp				while_2
 
store_exclamation_mark:
	load_ind		pointer
	and				mask_to_put_byte
	add				exclamation_mark
	store_ind       pointer
 
	load			len
	add				const_1
	store			len	
 
print_buffer:
	load_imm		len
	store 			pointer
 
	load_ind 		pointer
	and 			byte_mask
    store			loop_counter
 
	load			pointer
	add				const_1
	store			pointer
 
	load			loop_counter
 
while_3:
	beqz 			end
 
	load_ind		pointer
	and 			byte_mask
	store_ind		output_addr
 
	load			pointer
	add				const_1
	store			pointer
 
	load			loop_counter
	sub				const_1
	store			loop_counter
 
	jmp 			while_3
 
overflow:
    load_imm        0xCCCC_CCCC
    store_ind       output_addr
 
end:
    halt

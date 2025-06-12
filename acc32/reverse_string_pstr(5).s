	.data
reverse_message:	.byte 0, '_______________________________'
empty_space: 		.byte '___'
buffer:				.byte '_______________________________'
empty_space_2:      .byte '___'
input_addr:    		.word 0x80
output_addr:   		.word 0x84
loop_ctr: 	   		.word 0
ptr: 	   	   		.word 0
ptr2: 				.word 0
tmp:		   		.word 0
FF:	   		   		.word 255
one:	       		.word 1
ten: 	       		.word 10
overflow_count:		.word 32
overflow_er_value:  .word 0xCCCCCCCC
buf_const: 			.word 0x5F5F5F00
message_length: 	.word 0x0
 
	.text
	.org		0x88
 
_start:
	load_imm		buffer
	store	 		ptr	
 
read_input:	
	load_ind		input_addr
	and				FF
 
	store			tmp
	xor				ten
	beqz			store_message_length
 
	load			tmp
	store_ind		ptr
 
	load			ptr
	add				one
	store			ptr
 
	load			message_length
	add				one	
	store			message_length
	and				FF
	sub				overflow_count
	beqz			overflow_error
	bgt 			overflow_error
 
 
	jmp				read_input
 
store_message_length:
	load_imm		reverse_message
	store			ptr2
 
	load			message_length
	and				FF
	add				buf_const
	store_ind		ptr2
 
 
reverse_input:
 
	load			ptr
	sub				one
	store			ptr 
 
	load_ind 		ptr2
	and 			FF
    store			loop_ctr
 
	load			ptr2
	add				one
	store			ptr2
 
	load			loop_ctr
 
reverse_loop:
	beqz 			print_reverse_message
 
	load_ind		ptr
	and 			FF
	add				buf_const
	store_ind		ptr2
 
	load			ptr
	sub				one
	store			ptr
 
	load			ptr2
	add				one
	store 			ptr2
 
	load			loop_ctr
	sub				one
	store			loop_ctr
 
	jmp 			reverse_loop
 
 
print_reverse_message:
	load_imm		reverse_message
	store			ptr
 
	load_ind 		ptr
	and 			FF
    store			loop_ctr
 
	load			ptr
	add				one
	store			ptr
 
	load			loop_ctr
 
while_reverse_message:
	beqz 			end
 
	load_ind		ptr
	and 			FF
	store_ind		output_addr
 
	load			ptr
	add				one
	store			ptr
 
	load			loop_ctr
	sub				one
	store			loop_ctr
 
	jmp 			while_reverse_message
 
overflow_error:
	load			overflow_er_value
	store_ind		output_addr	
 
end:
    halt

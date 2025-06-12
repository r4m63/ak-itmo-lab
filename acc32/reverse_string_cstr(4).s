	.data
reverse_message:	.byte '___________________________________'
buffer:				.byte '\0__________________________________'
input_addr:    		.word 0x80
output_addr:   		.word 0x84
ptr1: 	   	   		.word 0x0
ptr2: 				.word 0x0
tmp:		   		.word 0x0
overflow_count:		.word 32
symbols_count:      .word 0x0
new_line_flag:		.word 0x1
const_FF:	   		.word 0xFF
const_0: 			.word 0x0
const_1:	       	.word 0x1
const_10: 	       	.word 0xA
buffer_const: 		.word 0x5F5F5F00
overflow_const:  	.word 0xCCCCCCCC
 
	.text
    .org    0x88
 
_start:
	load_imm		buffer
	add				const_1
	store	 		ptr1		
 
read_input:	
	load_ind		input_addr
	and				const_FF
	beqz			null_before_new_line
 
	store			tmp
	xor				const_10
	beqz			do_reverse
 
	load			tmp
	store_ind		ptr1
 
	load			ptr1
	add				const_1
	store			ptr1
 
	load            symbols_count
    add             const_1
    store           symbols_count
	xor				overflow_count
	beqz			overflow  
 
	jmp				read_input
 
null_before_new_line:
	load			const_0
	store			new_line_flag
	jmp				do_reverse	
 
do_reverse:
	load			ptr1
	sub				const_1
	store			ptr1
 
	load_imm		reverse_message
	store			ptr2
 
loop:	
	load_ind		ptr1
	and 			const_FF
	add				buffer_const
	store_ind		ptr2
	and				const_FF
	beqz 			print_result 	
 
	load			ptr1
	sub				const_1
	store			ptr1
 
	load			ptr2
	add				const_1
	store 			ptr2
 
	jmp 			loop
 
 
print_result:
	load_imm		reverse_message
	store			ptr1
 
while:
 
	load_ind		ptr1
	and 			const_FF
	beqz			check_new_line_flag
	store_ind		output_addr
 
	load			ptr1
	add				const_1
	store			ptr1
 
	jmp 			while
 
check_new_line_flag:
	load			new_line_flag
	bnez			end
 
	load			ptr1
	add				const_1
	store 			ptr1
 
get_remaining_input:
	load_ind		input_addr
	and				const_FF
	store			tmp
	xor				const_10
	beqz			finish_cstr
	load			tmp
	store_ind		ptr1
 
	load			ptr1
	add				const_1
	store			ptr1
 
    jmp				get_remaining_input
 
finish_cstr:
	load 			const_0
	add				buffer_const
	store_ind		ptr1
	jmp 			end
 
 
overflow:
	load			overflow_const
	store_ind		output_addr	
 
end:
    halt

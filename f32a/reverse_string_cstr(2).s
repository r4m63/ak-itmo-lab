	.data
buffer: 				.byte  '\0_______________________________'
input_port: 			.word  0x80
output_port:			.word  0x84
new_line_symb:			.word  0xA
put_byte_to_memory: 	.word  0xFFFFFF00
right_ptr: 				.word  0x0
saved_right_ptr:    	.word  -1
 
	.text
	.org     0x88
_start:
	@p input_port b!
	lit buffer a!
 
while_input_stream:
	@b
	lit 0xFF and
 
	dup
	@p new_line_symb
	xor
	if store_null_term
 
	check_is_null_term
 
	store_char_addr_from_a
	a
	dup
	lit -32 + 
	if overflow_error
	a!
	while_input_stream ;
 
store_null_term:
	a
	dup
	if stop_machine			\ empty string
	lit -1 +
	!p right_ptr
	lit 0
	store_char_addr_from_a	
 
preparation_for_reverse:
	drop
	lit buffer a!
	check_do_right_ptr_need_update
	@p right_ptr b!
 
reverse_loop:
	@ lit 0xFF and
	@b lit 0xFF and
	store_char_addr_from_a
	store_char_addr_from_b
 
	@p right_ptr
	lit -1 +
	dup
	!p right_ptr
	b!
 
	check_is_left_lt_right
	if preparation_for_print
 
	reverse_loop ;
 
preparation_for_print:
	lit buffer a!
	@p output_port b!
	print_cstr
	stop_machine ;
 
print_cstr:
	@+
	lit 0xFF and
	dup
	if print_cstr_ret
	!b
	print_cstr ;
 
print_cstr_ret:
	;
 
overflow_error:
	lit 0xCCCC_CCCC
	@p  output_port a! !
 
stop_machine:
    halt
 
check_do_right_ptr_need_update:
	@p saved_right_ptr
	-if update_right_ptr
	;
update_right_ptr:
	@p saved_right_ptr !p right_ptr
	;
 
check_is_null_term:
	dup
	lit -1 +
	-if return
	a lit -1 +
	!p saved_right_ptr
return:
	;
 
store_char_addr_from_a:
	@
	@p put_byte_to_memory and +
	!+
	;
 
store_char_addr_from_b:
	@b
	@p put_byte_to_memory and +
	!b
	;
 
 
check_is_left_lt_right:
	a
	@p right_ptr inv lit 1 +
	+
	-if return_0
return_1:
	lit 1
	;
return_0:
	lit 0
	;

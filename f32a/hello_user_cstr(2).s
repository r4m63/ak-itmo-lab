	.data
 
buf: 		  			.byte 'Hello, \0________________________'
question:	   	  		.byte 'What is your name?\n\0'
exclamation_mark: 		.word '!'
start_ptr: 				.word 0x7
max_ptr:				.word 30
new_line_symbol: 		.word 0xA
input_addr:       		.word 0x80
output_addr:      		.word 0x84
 
	.text
	.org 	0x88
 
_start:
	@p output_addr b!
	lit question a!
	print_cstring 
	@p start_ptr a!
	@p input_addr b!	
 
get_input_stream:
	@b
	dup
	check_is_it_null_symbol
	dup
	@p new_line_symbol
	xor
	if put_exclamation_and_null
	char_to_buf
	a
	dup
	@p max_ptr xor
	if overflow_error
	a!
	get_input_stream ;	
 
put_exclamation_and_null:
	@p exclamation_mark
	char_to_buf	
	lit 0x0
	char_to_buf
 
print_buf:
	@p output_addr b!
	lit buf a!
	print_cstring
	end ;
 
overflow_error:
	lit 0xCCCC_CCCC
	@p	output_addr a! !
end:
	halt
 
check_is_it_null_symbol:
	lit -1 +
	-if ret
	@p exclamation_mark
	char_to_buf
	;
 
 
 
print_cstring:	
	@+
	lit 0xFF and
	dup
	if ret
	!b
	print_cstring ;
 
ret:
	;	
 
char_to_buf:
	@ lit 0xFFFFFF00 and +
	!+
	;

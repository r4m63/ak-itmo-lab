	.data
string_len:			.byte  0x0
result_string: 		.byte  '_______________________________'
buffer: 			.byte  '_______________________________'
input_port: 		.word  0x80
output_port:		.word  0x84
new_line_code:		.word  0xA
buf_ptr: 			.word  0x0
mask_for_store:     .word  0xFFFFFF00
 
	.text
	.org     0x88
_start:
	@p input_port b!
	lit buffer a!
 
	lit 0
get_input:
	@b
	lit 0xFF and
	dup
	@p new_line_code
	xor
	if reverse_start
	!+
	lit 1 +			\ inc string_len
	dup
	lit -32 +
	if too_much_symbols
	get_input ;
 
 
reverse_start:
	drop            \ drop 0xA
	dup
    @p string_len
    @p mask_for_store and +
	!p string_len
	dup
	if before_print
	a
	lit -1 +
	!p buf_ptr
	lit result_string a!
 
 
do_reverse:
	@p buf_ptr
	move_letter
	!p buf_ptr
 
	lit -1 +
	dup
	if before_print
	do_reverse ;
 
move_letter:
	dup
	b!
	@b
    lit 0xFF and
    @ @p mask_for_store and
    +
	!+	
	lit -1 +
	;
 
before_print:
	lit result_string a!
	@p output_port b!
	@p string_len
    lit 0xFF and
	print_pstr_string
	halt_machine ;
 
print_pstr_string:
	dup
	if print_finish
	@+
	lit 0xFF and
	!b
	lit -1 +
	print_pstr_string ;
 
print_finish:
	;
 
too_much_symbols:
	lit 0xCCCC_CCCC
	@p  output_port a! !
 
halt_machine:
    halt

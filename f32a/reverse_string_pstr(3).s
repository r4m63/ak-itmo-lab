	.data
reverse_str: 		.byte  0, '__________________________________'
buffer: 			.byte  '__________________________________'
input_port: 		.word  0x80
output_port:		.word  0x84
put_byte_fix:		.word  0x5f5f5f00
ptr:	 			.word  0
 
	.text
	.org			0x88
 
_start:
	lit buffer a!
	@p input_port b!
 
read_input:
	@b 
	lit 0xFF and
	dup
	lit 0xA xor
	if  reverse_start
	!+
 
	@p  reverse_str
	inc_and_check_length
	!p  reverse_str
 
	read_input ;
 
reverse_start:
	drop 
	@p	reverse_str
	lit 0xFF and 
	dup
	if  print_start
 
	a 
	lit -1 +
	!p  ptr
	lit reverse_str lit 1 + a!
 
 
reverse_loop:
	@p ptr
	move_char
	!p ptr
 
	lit -1 +
	dup
	if  print_start
	reverse_loop ;
 
 
print_start:
	lit reverse_str lit 1 + a!
	@p  output_port b!				
	@p  reverse_str
    lit 0xFF and
	print_pstr
	end ;
 
buffer_overflow:
	lit 0xCCCCCCCC
	@p  output_port b! !b
 
end:
    halt
 
 
inc_and_check_length:
	lit 0xFF and 
	lit 1 +
	dup
	lit -32 +
	if  buffer_overflow
	;
 
move_char:
	dup
	b!  @b
    lit 0xFF and
    @p  put_byte_fix +
	!+	
	lit -1 +
	;
 
print_pstr:
	dup
	if  print_return
	@+
	lit 0xFF and
	!b
	lit -1 +
	print_pstr ;
 
print_return:
	;

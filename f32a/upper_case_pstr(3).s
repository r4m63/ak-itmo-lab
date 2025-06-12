	.data
buf:		   			.byte 0, '________________________________'
extra_space:            .byte '___'
in_addr:       			.word 0x80
out_addr:      			.word 0x84
overflow_error_value: 	.word 0xCCCCCCCC
 
	.text
	.org 	0x88
_start:
	@p in_addr b!
	lit buf lit 1 + a!	
 
next_letter:
	@b
	lit 0xff and
 
	dup
	lit 0xA
	xor
	if print_buf
 
	dup
	lit -97 +
	-if make_bigger
	put_letter ; 
 
make_bigger:
	lit -32 +
 
 
put_letter:		
	lit 0x5F5F5F00 +
	!+
 
    @p 	buf
	lit 1 +
	dup
	check_overflow
    !p 	buf
	next_letter ;	
 
check_overflow:
    lit 0xff and
	lit 32 xor
	if return_overflow_error
	;
 
print_buf:
	@p	out_addr b!
	@p 	buf
	lit 0xFF and
	lit buf lit 1 + a!
	print_pstr ;
 
return_overflow_error:
	@p overflow_error_value
	@p	out_addr b!
	!b
	end ;
 
print_pstr:	
	@+
	lit 0xFF and
	!b
	lit -1 +
	dup
	if 	end
	print_pstr ;
 
end:
	halt

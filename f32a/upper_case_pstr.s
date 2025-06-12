	.data
buf:		   			.byte 0, '________________________________'
in_addr:       			.word 0x80
out_addr:      			.word 0x84
check_is_it_small: 		.word -96
change_size_const:		.word -32
ptr_overflow: 			.word 32
put_byte_to_mem_mask:   .word 0xFFFFFF00
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
 
	make_capital_if_small_letter
	put_letter
 
	@p 	buf
	lit 1 +
	dup
	!p  buf
 
	lit 0xff and
	@p ptr_overflow xor
	if return_overflow_error	
	next_letter ;		
 
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
 
put_letter:		
	@ 
	@p put_byte_to_mem_mask and
	+
	!+
	;
 
make_capital_if_small_letter:
	dup
	@p check_is_it_small +
	inv lit 1 +
	-if return
	@p change_size_const +
return:
	;

	.data
 
input_addr: 		.word 	0x80
output_addr: 		.word 	0x84
reverse: 			.word	0x0
binary:				.word	0x0
 
	.text
 
_start:
	@p	input_addr	a! @
	dup
	!p	binary
 
	lit 31 >r
next_bit:
	dup
	lit 1 and
	@p	reverse
	add_to_reverse
	!p	reverse
	2/
	next next_bit
	checking ;
 
add_to_reverse:
	2*
	+
	;
 
checking:
	@p reverse @p binary xor
	if return_true
 
return_false:
	lit 0
	print_result ;
 
return_true:
	lit 1
 
print_result:
	@p output_addr a! !
 
	halt

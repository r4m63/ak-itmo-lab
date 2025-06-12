	.data
input_addr:    				.word 0x80
output_addr:   				.word 0x84
FF_mask: 	   				.word 0xFF
shiftl_count: 				.word 24
shiftr_count_const: 		.word 7
result: 	   				.word 0
 
	.text
	.org 		0x88
 
_start:
	@p input_addr b! @b a!
 
loop:
	a
	@p FF_mask and
	@p shiftl_count
	dup
	if without_left_shifts
	left_shifts
	@p result + !p result
	a
	@p shiftr_count_const
	right_shifts
	a!
	@p shiftl_count
	lit -8 +
	!p shiftl_count
	loop ;
 
without_left_shifts:
	drop
	@p	result + !p result
	return_result ;
 
 
 
right_shifts:
	>r
shiftr_loop:
	2/
	next shiftr_loop
	;
 
left_shifts:
	lit -1 + >r
shiftl_loop:
	2*
	next shiftl_loop
	;
 
return_result:
	@p output_addr a!
	@p result 
	!
 
	halt

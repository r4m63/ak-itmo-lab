	.data
input_addr:		.word 0x80
output_addr: 	.word 0x84
 
	.text
    .org 0x88
_start:
    @p  input_addr  a! @
	dup
	lit -1 + 
	-if sum_even_n
	lit -1				\ error value
	write_output ;
 
sum_even_n:
	dup
	lit 1 and
	make_even_if_odd
	count_members
	dup
	lit 1 +	
	multiply			\ mean * count_members
	write_output ;
 
 
make_even_if_odd:
	if	return_odd
	lit -1 +
return_odd:
	;
 
count_members:
	2/
	;
 
multiply:
	a!
	lit 0
	lit 31 >r             
multiply_do:
    +*                   
    next multiply_do
 
	drop drop a
	dup
	-if	multiply_end
	overflow ;
 
multiply_end:
	;
 
overflow:
	lit 0xCCCCCCCC
 
write_output:
	@p	output_addr	a! !
    halt

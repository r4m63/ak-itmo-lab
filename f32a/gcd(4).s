	.data
input_addr:		.word 	0x80
output_addr:	.word 	0x84
divisor: 		.word  	0x88
num_a:			.word  	0x0
num_b:			.word   0x0
 
	.text
 
_start:
	@p 	input_addr	a!
	@
	!p	num_a
	@
	!p 	num_b
 
while:
	@p	num_a
	@p 	num_b
	dup
	if	write_output
 
	@p 	divisor b!
    !b
 
    a!
    get_remainder
 
	@p 	num_b
	!p 	num_a
 
	!p	num_b
	while ;
 
get_remainder:
    lit 0 lit 0
    lit 31 >r
divide_step:
    +/
    next divide_step
	drop
    ;
 
write_output:
	@p 	output_addr a!
	@p 	num_a
	!
	halt

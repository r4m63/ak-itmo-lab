	.data
input_addr:    .word 0x80
output_addr:   .word 0x84
result:		   .word 0
 
	.text
_start:
	@p input_addr b!
	@b
 
	lit 31 >r
loop:
	dup
	lit 1 and
	lit -1 +
	if count_bit	
	2/
	next loop
	count_ones_end ;
 
count_bit:
	@p	result
	lit 1 +
	!p result
	2/
	next loop
 
count_ones_end:
	@p output_addr b!
	@p result 
	!b
	halt

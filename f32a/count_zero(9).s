	.data
input_addr:    .word 0x80
output_addr:   .word 0x84
count:		   .word 0x0
 
	.text
 
_start:
	@p input_addr a! @
 
	lit 31 >r
loop:
	dup
	inc_count_if_zero	
	2/
	next loop
	count_zero_end ;
 
inc_count_if_zero:
    inv lit 1 and       \ 0 -> 1 , 1 -> 0						
	@p count +
	!p count
	;
 
count_zero_end:
	@p output_addr a!
	@p count 
	!
 
	halt

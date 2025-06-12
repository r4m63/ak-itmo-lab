	.data
input_addr:    		.word 0x80
output_addr:   		.word 0x84
result:	   	   		.word 0x0
mask_older_bit:		.word 0x80000000
	.text
_start:
	@p input_addr a! @
 
	lit 31 >r
while:
	dup
	@p mask_older_bit and
	if finish_loop
	return_count ;
finish_loop:
	2*
	inc_count
	next while
    return_count ;
 
inc_count:
   @p result
   lit 1 +
   !p result
   ;
 
return_count:
	@p output_addr a!
	@p result
	!
end:
    halt

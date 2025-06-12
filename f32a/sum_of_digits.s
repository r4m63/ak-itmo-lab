	.data
 
input_addr: 		.word 0x80
output_addr: 		.word 0x84
divisor: 			.word 0x88
sum: 				.word 0	
 
	.text
 
_start:
 
	@p input_addr a! @
	abs_n
 
while:
	dup
	if write_sum
 
	return_quotient_and_digit
    over
	@p sum + !p sum
	while ;
 
 
write_sum:
	drop
	@p output_addr a!
	@p sum !
	halt
 
 
return_quotient_and_digit:
	lit 10					   	   \ divisor
 
	@p 	divisor b! !b                         
 
    a!                             \ A <- dividend
    lit 0 lit 0                    \ quotient:digit:[]
 
    lit 31 >r                     
multiply_begin:
    +/                       
    next multiply_begin					
	;
 
abs_n:
    dup
	-if ret
	inv lit 1 + 	
ret:
	;

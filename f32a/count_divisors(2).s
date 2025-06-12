	.data
 
in_addr: 			.word	0x80
out_addr: 			.word 	0x84
divisor:			.word   0x88
loop_counter:		.word   0x1
divisors_count: 	.word   0x0
 
	.text
	.org 	0x88
_start:
	@p in_addr a! @
	dup
	lit -1 +
	-if	count_divisors_start
	incorrect_input_value ;
 
count_divisors_start:
	dup
	lit -1 + >r
count_divisors_loop:
	dup
	@p loop_counter
	get_remainder
	upd_divisors_count
	@p loop_counter
	lit 1 +
	!p loop_counter
	next count_divisors_loop
	@p divisors_count
	count_divisors_end ;
 
upd_divisors_count:
	lit -1 +			\ if the rem is 0, then we get a negative number
	-if return
	@p divisors_count
	lit 1 +
	!p divisors_count
 
return:
	;
 
 
get_remainder:
	@p 	divisor b!                 
    !b                            
    a!                           
    lit 0 lit 0                    
    lit 31 >r
multiply_begin:
    +/                            
    next multiply_begin
	drop
    ;
 
incorrect_input_value:
	lit -1
 
count_divisors_end:
	@p out_addr a! !
	halt

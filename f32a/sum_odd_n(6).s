	.data
 
in_port:		.word 0x80
out_port: 		.word 0x84
overflow_er:	.word 0xcccccccc
 
	.text
 
_start:
    @p in_port b!
    @b
 
	dup
	lit -1 + 
	-if sum_odd_n_start
	return_minus_one ;
 
sum_odd_n_start:
	dup
	lit 1 and
	lit -1 +	\ 0 -> -1, 1 -> 0
	+
 
	lit 1 +
	2/			\ mean:[]
 
	dup			\ count_odd_n:mean:[]
 
	mean_mul_count
	return_result ;
 
 
mean_mul_count:
	a!
	lit 0
 
	lit 31 >r                \ for R = 31
multiply_do:
    +*                       \ mres-high:mean:[]; mres-low in a
    next multiply_do
 
	drop
	drop
	a
	dup
	-if	mul_callback
	return_overflow ;
 
mul_callback:
	;
 
return_minus_one:
	lit -1
	return_result ;
 
return_overflow:
	@p overflow_er
 
return_result:
	@p out_port b!
	!b
	halt

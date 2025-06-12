    .data
 
input_addr:       .word  0x80
output_addr:      .word  0x84
err_n:            .word   -1
overflow_value:   .word  0xCCCC_CCCC
 
    .text
.org 0x88
 
_start:
    @p input_addr a! @
    dup
	lit -1 +
	-if	sum_n
	error_n ;
sum_n:
    dup lit 1 + 
    a!
    lit 0
    multiply
	dup
	if error_res
    2/
	write_result ;
 
error_res:
    @p overflow_value
	write_result ;
 
error_n:
    @p err_n
 
write_result:
    @p output_addr a! !
    halt
 
 
multiply:
    lit 31 >r               
multiply_do:
    +*                      
    next multiply_do
	if ret					\ check high part of result
	lit 0 a!          	
ret:
    drop a    
    ;

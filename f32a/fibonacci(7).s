    .data
 
input_addr:      	.word  0x80
output_addr:     	.word  0x84
 
const_overflow:  	.word  0xCCCCCCCC
const_out_of_bnd: 	.word  0xFFFFFFFF
 
const_first_numb: 	.word  0x00
const_second_numb: 	.word  0x01
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
    .text
 
dec:
    lit -1 +
    ;
 
inc:
    lit 1 +
    ;
 
push_a_to_s:
    a over
    ;
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
check_overflow:
    dup
    inv inc
    -if check_overflow_true
 
    lit 1
    ;
 
check_overflow_true:
    lit 0
    ;
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
check_invalid_input:
    dup inv
    -if check_invalid_input_true
 
    lit 1
    ;
 
check_invalid_input_true:
    lit 0
    ;
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
    .text
    .org 0x88
 
fibonacci:
    check_invalid_input
    if fibonacci_inv_input
 
    dup
    if fibonacci_return
 
    dup dec
    if fibonacci_return
 
fibonacci_init:
    dec dec >r
    @p const_first_numb      \ x:[]
    @p const_second_numb     \ y:x:[]
 
fibonacci_loop:
    dup a!                   \ A:y
    +                        \ x+y:[]
 
    check_overflow
    if fibonacci_overflow
 
    push_a_to_s              \ x+y:y:[] , A:y
 
    next fibonacci_loop
 
fibonacci_return:
    ;
 
fibonacci_overflow:
    drop
    @p const_overflow
    r> drop
    ;
 
fibonacci_inv_input:
    drop
    @p const_out_of_bnd
    ;
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
_start:
    @p input_addr a! @
    fibonacci
    @p output_addr a! !
    halt

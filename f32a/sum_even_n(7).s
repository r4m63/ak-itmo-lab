    .data
input_addr:     .word 0x80
output_addr:    .word 0x84
 
    .text
    .org 0x88
 
_start:
    @p input_addr a! @   
    dup
    lit -1
    +
    -if sum_even_n_entry    
    drop
    lit -1
    jump_to_write
 
sum_even_n_entry:
    sum_even_n_func
 
jump_to_write:
    write_output_and_halt
 
sum_even_n_func:
    dup
    lit 1
    and
    make_even_if_odd
    count_members
    dup
    lit 1
    +
    multiply
    dup
    -if multiply_end
    overflow
 
multiply_end:
    ;
 
make_even_if_odd:
    if return_odd_label
    lit -1
    +
    return_odd_label:
    ;
 
count_members:
    2/
    ;
 
multiply:
    a!                 
    lit 0             
    lit 31
    >r    
 
multiply_do:
    +*
    next multiply_do
    drop drop a       
    ;
 
overflow:
    lit 0xCCCCCCCC   
    ;
 
write_output_and_halt:
    @p output_addr a!
    !
    halt

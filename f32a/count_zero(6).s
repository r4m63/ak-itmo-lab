    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
 
_start:
    @p input_addr a! @       \ n:[]
 
    inv
    lit 0 a!
 
    count_ones
    @p output_addr a! !
    halt
 
count_ones:
    lit 31 >r
count_ones_loop:
    dup lit 1
    and \ and:~n[]
    a + a!
    2/
    next count_ones_loop
    a
    ;

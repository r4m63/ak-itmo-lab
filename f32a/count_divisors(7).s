    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
int:             .word  0x01
delimoe:         .word  0x00
 
    .text
    .org 0x88
 
_start:
    @p input_addr a! @
    dup
    if is_zero
    dup
    -if is_positive
    drop
    lit -1
    @p output_addr a! !
    halt
 
is_zero:
    drop
    lit -1
    @p output_addr a! !
    halt
 
is_positive:
    !p delimoe
    count_divisors
    r>
    @p output_addr a! !
    halt
 
count_divisors:
    lit 0 >r
    lit int
    b!
    first_loop ;
 
first_loop:
    @p delimoe a!
    lit 0
    lit 0
    lit 31
    >r
 
steps_for_del:
    +/
    next steps_for_del
    drop
    if del
 
not_del:
    continue ;
 
del:
    r>
    lit 1
    +
    >r
    continue ;
 
 
continue:
    @p int
    inv
    lit 1
    +
    @p delimoe
    +
    if end
    @p int
    lit 1
    +
    !p int
    first_loop ;
 
end:
    r>
    r>
    over
    >r
    >r
    ;

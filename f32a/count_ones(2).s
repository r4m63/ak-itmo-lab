    .data
input_start:     .word  0x80
output_start:    .word  0x84
 
bit_mask:        .word  0x00000001
nonnegative_mask: .word  0x7FFFFFFF
 
    .text
_start:
 
N_to_stack:
    @p input_start
    a!
    @
    dup
    -if nonnegative
 
negative:
    apply_nonnegative_mask
    lit 0x01                 \ COUNTER (CNTR)
    N_to_A ;
nonnegative:
    lit 0x00                 \ COUNTER (CNTR)
N_to_A:
    over
    a!
 
count_loop:
    a
 
    dup
    if break
 
    apply_bit_mask
    shift_right
 
    count_loop ;
 
break:
    drop
CNTR_to_OUT:
    @p output_start
    a!
    !
exit:
    halt
 
 
 
 
    \ ============ SUBROUTINES ===========
 
apply_bit_mask:
    @p bit_mask
    apply_mask
    +
    ;
 
apply_nonnegative_mask:
    @p nonnegative_mask
    apply_mask
    ;
 
apply_mask:
    and
    ;
 
shift_right:
    a
    2/
    a!
    ;

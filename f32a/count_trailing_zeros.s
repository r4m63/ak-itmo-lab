    .data

input_addr:     .word 0x80
output_addr:    .word 0x84
mask:           .word 0x1

    .text
    .org 0x88

_start:
    read_input
    check_0
    if call_write_output
    count_trailing_zeros

call_write_output:
    write_output
    end

read_input:
    @p input_addr a! @
    ;

check_0:
    dup
    if load32
    lit -1
    ;

load32:
    drop
    lit 32
    lit 0
    ;

count_trailing_zeros:
    lit 32 >r
    lit 0
    over

count_trailing_zeros_loop:
    dup
    @p mask
    and
    if right_shift
    exit ;

right_shift:
    2/
    over
    lit 1
    +
    over
    next count_trailing_zeros_loop

exit:
    drop
    r> drop
    ;

write_output:
    @p output_addr b! !b
    ;

end:
    r> drop
    halt

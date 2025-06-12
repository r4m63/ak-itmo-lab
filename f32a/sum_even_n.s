    .data

input_address: .word 0x80
output_address: .word 0x84
overflow_value: .word 0xCCCCCCCC

    .text

read_address:
    a!
    @
    ;

write_address:
    a!
    !
    ;

mul:
    lit 0
    lit 31
    >r

mul_loop:
    +*
    next mul_loop
    over
    drop
    if mul_no_overflow
    @p overflow_value
    ;

mul_no_overflow:
    a
    dup
    -if mul_no_negative
    drop 
    @p overflow_value
    ;

mul_no_negative:
    ;

square:
    dup
    a!
    mul
    ;

is_valid:
    dup
    lit -1
    + 
    -if true

false:
    lit -1
    ;

true:
    lit 0
    ;

compare:
    inv
    lit 1
    +
    +
    if equal

not_equal:
    lit 1 ;

equal:
    lit 0 ;

_start:
    @p input_address
    read_address
    is_valid 
    if good_value

bad_value:
    lit -1
    end ;

good_value:
    2/
    dup
    square
    dup
    @p overflow_value
    compare
    if overflow
    +
    end
    ;

overflow:
    @p overflow_value

end:
    @p output_address
    write_address
    halt

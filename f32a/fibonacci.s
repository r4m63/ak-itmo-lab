    .data

input_addr:     .word 0x80
output_addr:    .word 0x84

    .text

_start:
    read_input
    fibonacci
    write_output
    end

read_input:
    @p input_addr a! @
    ;

fibonacci:
    dup
    lit -2
    +
    -if fib_continue
    dup
    -if return_num

incorrect_range:
    lit -1
    ;

return_num:
    ;

fib_continue:
    lit -2 +
    >r
    lit 0 a!
    lit 1

fib_loop:
    dup
    a
    +
    dup
   -if c_fib_loop

overflow:
    drop drop r> drop
    lit 0xCCCCCCCC
    fib_end ;

c_fib_loop:
    over
    a!
    next fib_loop

fib_end:
    ;

write_output:
    @p output_addr b! !b
    ;

end:
    r> drop
    halt

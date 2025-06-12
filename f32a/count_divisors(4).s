    .data
 
input_addr:     .word 0x80
output_addr:    .word 0x84
divisible:      .word 0
divisor:        .word 0
 
    .text
    .org 0x88
 
_start:
    read_input
    check_ranges
    count_divisors_prep
    write_output
 
read_input:
    \ /------------------- T <- input_addr
    \ |           /------- T -> A
    \ |           |  /---- [A] -> T
    \ v           v  v
    @p input_addr a! @
    !p divisible
    ;
 
check_ranges:
    @p divisible dup    \ [x:x]
    if x_not_in_range   \ [x]
    dup                 \ [x:x]
    -if x_is_positive   \ [x]
 
x_not_in_range:
    drop                \ []
    lit -1              \ [-1]
    write_output ;
 
x_is_positive:
    drop
    ;
 
count_divisors_prep:
    count_divisors
    r>
    ;
 
count_divisors:
    lit 0 >r            \ r:0
    lit divisor b!      \ b <- divisor
    main_loop ;
 
main_loop:
    @p divisible a!     \ a <- divisible
    lit 0
    dup
    lit 31 >r
 
division_step:
    +/
    next division_step
    drop
    if del              \ if remainder == 0 => divisor / divisible -> +1
 
not_del:
    continue ;
 
del:
    r> lit 1 + >r
    continue ;
 
continue:
    @p divisor
    inv lit 1 +
    @p divisible
    +
    if end
    @p divisor
    lit 1 +
    !p divisor
    main_loop ;
 
end:
    r>
    r>
    over
    >r
    >r
    ;
 
write_output:
    \ /-------------------- T <- output_addr
    \ |            /------- T -> B
    \ |            |  /---- [B] -> T
    \ v            v  v
    @p output_addr b! !b
 
exit:
    halt

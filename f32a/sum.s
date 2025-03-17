.data

input_address: .word 0x80
output_address: .word 0x84
overflow_value: .word 0xCCCCCCCC

.text

read_address:   \ read_address(addr)
    a!
    @
    ;

write_address:  \ write_address(addr, value)
    a!
    !
    ;

mul:    \ (a, b) -> a*b, a - value in A register, b - second value from top of the stack
    lit 0           \ High part of the multiplication result (NOT USED)
    lit 31
    >r
mul_do:
    +*
    next mul_do
    over
    drop
    if ok_1
    
    @p overflow_value
    ;
ok_1:
    a

    dup
    -if ok_2
    
    drop 
    @p overflow_value
    ;

ok_2:
    ;

square: \ x*x
    dup
    a!
    mul
    ;

is_valid:   \is_valid(n), checks if n > 0, returns 0 if yes, -1 otherwise
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

compare:    \ compare(a, b), returns 0 if a == b, 1 otherwise, doesn't duplicate stack values
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

    \ if (stack.top() == overflow_value)
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
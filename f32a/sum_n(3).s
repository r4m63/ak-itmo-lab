    .data
 
input_addr:       .word  0x80
output_addr:      .word  0x84
err_n:            .word   -1
err_res:          .word   0xCCCC_CCCC
 
    .text
.org 0x88
error_res:
    @p err_res
    @p output_addr a! !
    halt
 
error_n:
    @p err_n
    @p output_addr a! !
    halt
 
_start:
    @p input_addr a! @
    dup if error_n dup inv -if error_n
 
    progression
 
    dup if error_res dup inv -if error_res
    @p output_addr a! !
    halt
 
 
multiply:
    lit 31 >r                \ for R = 31
multiply_do:
    +*                       \ mres-high:acc-old:n:[]; mres-low in a
    next multiply_do
    if ok
    error_res ;
ok:
    drop a              \ mres-low:n:[] => acc:n:[]
    ;
 
 
progression:  \ S = (1 + n) * n / 2
    dup lit 1 +
    a!
    lit 0
    multiply
    2/
    ;

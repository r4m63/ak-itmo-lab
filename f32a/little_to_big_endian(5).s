.data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
.text
 
_start:
    @p input_addr a!
    @ 
    swap_endian
    @p output_addr a!
    !
    halt
 
shift_left:
    >r
shift_left_do:
    2*
    next shift_left_do 
    ;
 
shift_right:
    >r
shift_right_do:
    2/
    next shift_right_do 
    ;
 
swap_endian:
    a! 
    a
    lit 0xff and
    lit 23 shift_left
 
    a
    lit 0xff00 and
    lit 7 shift_left
    +
 
    a
    lit 0xff0000 and
    lit 7 shift_right
    +
 
    a
    lit 0xff000000 and
    lit 23 shift_right
    lit 0xff and 
    +
    ;

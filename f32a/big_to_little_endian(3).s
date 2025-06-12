    .data
input:           .word  0x80
output:          .word  0x84
 
    .text
    .org 0x100
_start:
    @p input a!
    @p output b!
    @
    dup dup dup
    _shift_right
    _shift_right
    _shift_right
    lit 0x000000FF and
    over
    _shift_right
    lit 0x0000FF00 and
    xor
    over
    _shift_left
    lit 0x00FF0000 and
    xor
    over
    _shift_left
    _shift_left
    _shift_left
    lit 0xFF000000 and
    xor
    !b
    halt
_shift_right:
    2/ 2/ 2/ 2/
    2/ 2/ 2/ 2/
    ;
_shift_left:
    2* 2* 2* 2*
    2* 2* 2* 2*
    ;

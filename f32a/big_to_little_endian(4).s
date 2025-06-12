     .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
 
    .org 0x100
_start:
    @p input_addr
    a!
    @
 
    swap4bytes
 
    @p output_addr
    a!
    !
    halt
 
swap2bytes: \(0xXXXX3412) -> 0xXXXX1234
    dup                      \ save the higher bits to restore in the end
    lit 0xFFFF0000
    and
    >r
 
    lit 0x0000FFFF           \ cut bytes for the algorithm
    and
 
    dup                      \ actual start of the algorithm
    lit 0xFF                 \ cut and hide the lower byte to the return stack
    and
    >r
 
    lit 7                    \ shift the upper byte to new position
    >r
shift_right2:
    2/
    next shift_right2
 
    r>                       \ restore the lower byte and shift to new position
    lit 7
    >r
shift_left2:
    2*
    next shift_left2
 
    +                        \ combine bytes in new positions
 
    r>                       \ restore the higher bits of initial input
    +
 
    ;
 
 
swap4bytes:
 \
    dup
    lit 0xFFFF               \ cut and hide the lower byte to the return stack
    and
    >r
 
    lit 15                   \ shift the upper half to new position
    >r
shift_right4:
    2/
    next shift_right4
 
    lit 0xFFFF
    and                      \ shift right spread sign
 
    swap2bytes               \ swap bytes in the half
 
    r>                       \ restore the lower half and shift to new position
    swap2bytes               \ swap bytes in the half
    lit 15
    >r
shift_left4:
    2*
    next shift_left4
 
    +                        \ combine halves in new positions
 
    ;

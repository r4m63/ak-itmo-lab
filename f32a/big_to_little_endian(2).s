.data
 
input_value_addr:    .word  0x80
result_addr:         .word  0x84
first_byte_mask:     .word  0xFF000000
second_byte_mask:    .word  0x00FF0000
third_byte_mask:     .word  0x0000FF00
fourth_byte_mask:    .word  0x000000FF
 
shift_temp:          .word  0
 
.text
.org 0x100
_start:
    @p input_value_addr a! @       
    dup a!
 
    big_to_little
 
    @p result_addr a! !
    halt
 
 
shift_left:
    >r
shift_left_loop:
    !p shift_temp @p shift_temp
    if shift_return
    @p shift_temp
    2*
    next shift_left_loop
    ;
 
shift_right:
    >r
shift_right_loop:
    !p shift_temp @p shift_temp
    if shift_return
    @p shift_temp
    2/
    next shift_right_loop
    ;
 
shift_return:
    r>
    drop
    lit 0
    ;
 
 
big_to_little:
    @p first_byte_mask and
    lit 23 shift_right
    @p fourth_byte_mask and  
 
    a
    @p second_byte_mask and
    lit 7 shift_right
 
    a
    @p third_byte_mask and
    lit 7 shift_left
 
    a
    @p fourth_byte_mask and
    lit 23 shift_left
 
    + + +
    ;

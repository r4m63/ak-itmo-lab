    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
mask_left:       .word  0x80000000
mask_mask:       .word  0x40000000
mask_right:      .word  0x00000001
 
    .text
    .org 0x100
_start:
    @p input_addr a! @
    is_pal
    @p output_addr a! !
    halt
 
is_pal:
    lit 15 >r
 
is_pal_loop:
    dup
    dup
 
left_check:
    @p mask_left
    and
    if left_null
    lit 1
    over
    right_check ;
 
left_null:
    lit 0
    over
 
right_check:
    @p mask_right
    and
    if right_null
    lit 1
    final_comparison ;
 
right_null:
    lit 0
 
final_comparison:
    xor
    if continue_loop
 
return_false:
    r> drop drop
    lit 0
    ;
 
continue_loop:
    @p mask_left
    2/
    @p mask_mask
    and
    !p mask_left
    @p mask_mask
    2/
    !p mask_mask
    @p mask_right
    2*
    !p mask_right
    next is_pal_loop
 
return_true:
    drop
    lit 1
    ;

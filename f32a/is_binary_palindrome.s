    .data
    .org         0x90

strt_mask_top:   .word  2147483648
strt_mask_bot:   .word  1
n:               .word  0
input_addr:      .word  0x80
output_addr:     .word  0x84

    .text

_start:
    @p input_addr a! @
    !p n
    initial ;

while:
    shift_and_save

initial:
    @p strt_mask_bot
    lit 0x10000
    sub_T_S
    if end_true
    @p strt_mask_bot
    @p strt_mask_top
    +
    @p n
    and
    a! a
    if while
    a
    @p strt_mask_bot
    @p strt_mask_top
    +
    sub_T_S
    if while

end_false:
    lit 0
    @p output_addr a! !
    halt

sub_T_S:
    inv
    lit 1
    +
    +
    ;

shift_and_save:
    @p strt_mask_bot
    2*
    !p strt_mask_bot
    @p strt_mask_top
    2/
    a! a
    -if save
    a
    @p strt_mask_top
    sub_T_S
    !p strt_mask_top
    ;

save:
    a
    !p strt_mask_top
    ;

end_true:
    lit 1
    @p output_addr a! !
    halt

    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
last_sec_num:    .word  0
last_num:        .word  1
neg_mask:        .word  10000000000000000000000000000000
 
    .text
    .org 0x200
_start:
    @p 0x80 dup
    @p neg_mask and inv
    -if neg_case             \проверка на отрицательность
    dup
    lit -46 +
    -if err                  \проверка на слишком большое число Фибоначчи
    dup
    if too_small             \если 0
    dup                      \
    lit -1 +                 \или 1
    if too_small             \вернуть его
 
    lit -1 +
    a!
    calc 
    end
err:
    lit 0xCCCCCCCC
    dup
    end
neg_case:
    lit -1
    dup
    end
too_small:
    lit 1
end:
    drop
    !p 0x84
    halt
 
calc:
    @p last_sec_num
    @p last_num +
    a lit -1 +
    dup
    if end_calc
    a!
 
    @p last_num
    !p last_sec_num
    !p last_num
    calc ;
end_calc:
    ;

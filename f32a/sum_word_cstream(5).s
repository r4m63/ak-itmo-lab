    .data
 
input_addr:     .word 0x80
output_addr:    .word 0x84
sum_low:        .word 0
sum_high:       .word 0
input_high:     .word 0
const_minus_1:  .word 0xFFFFFFFF
 
    .text
    .org 0x88
 
_start:
    set_input_addr
    sum_loop
    write_output
    end
 
set_input_addr:
    \ /------------------- T <- input_addr
    \ |           /------- T -> A
    \ |           |  
    \ v           v 
    @p input_addr a!
    ;
 
sum_loop:
    lit 0                       \ DS: 0 ; need this to sum with sum_high
    @p sum_high                 \ DS: sum_high:0
    lit 1                       \ DS: 1:sum_high:0 ; eam_enable flag
 
    @                           \ T <-- [A]
    dup                         \ DS: x:x:1:sum_high:0
    -if input_high_set_zero
 
input_high_set_minus_one:
    @p const_minus_1            \ DS: -1:x:1:sum_high:0
    !p input_high               \ input_high <-- -1 ; DS : x:1:sum_high:0
    continue_sum_loop ;
 
input_high_set_zero:
    lit 0                       \ DS: 0:x:1:sum_high:0
    !p input_high               \ input_high <-- 0
 
continue_sum_loop:
    dup                         \ DS: x:x:1:sum_high:0
    if end_sum                  \ if (x == 0) ==> end_sum ; DS: x:1:sum_high:0
    add64
    sum_loop ;
 
add64:
    @p sum_low                  \ DS: sum_low:x:1:sum_high:0
    +                           \ DS: sum_low+x:1:sum_high:0
    !p sum_low                  \ sum_low <-- sum_low+x
 
    eam                         \ enable EAM ; DS: sum_high:0
    +                           \ DS: sum_high+0+Carry
    @p input_high               \ DS: input_high:sum_high+0+Carry
    +                           \ DS: input_high+sum_high+0+Carry
    !p sum_high                 \ sum_high <-- input_high+sum_high+0+Carry
    lit 0 eam                   \ disable EAM
    ;
 
end_sum:
    drop                        \ DS: _ (delete x from DS)
    ;
 
write_output:
    \ /-------------------- T <- output_addr
    \ |            /------- T -> B
    \ |            |
    \ v            v
    @p output_addr b!
 
    @p sum_high                 \ T ← sum_high
    !b                          \ [output_addr] <-- T
 
    @p sum_low                  \ T ← sum_low
    !b                          \ [output_addr] <-- T
 
    ;
 
end:
    halt

    .data
 
buf:             .byte  '____________________________________'
output_addr:     .word  0x84
input_addr:      .word  0x80
 
    .text
    .org 0x100
 
_start:
    @p input_addr b!         \ input addr -> b
 
    lit buf
    lit 1 + a!               \ buf addr -> a; +1 for pstr len
 
    lit 0x20                 \ buf size
    lit 0 over               \ is possible to capital case flag
 
read_input:
    dup
    if overflow              \ if buf is overflow
    over
 
    @b lit 255 and           \ last byte of word
 
    dup lit -10 +
    if end_of_input          \ if '\n' then end of input
 
    check_symbol             \ check symbol for capitalize or decapitalize
 
    over                     \ now stack: [current symbol, flag, counter]
 
    lit 0x5f5f5f00 +         \ mask to save the buf values
    !+                       \ save in buf
    over
 
    lit -1 +                 \ capacity -= 1
    read_input ;
 
end_of_input:
    drop                     \ del last symbol
    drop                     \ del flag
    dup lit -32 +            \ check if it is '\n' string and go to overflow
    if overflow
    lit 0x1f xor
    lit 1 +                  \ count of readed symbols
 
    lit buf a!
    @ lit 0xffffff00 and     \ store the count of readed symbols in the beggining of string
    + !
 
go_to_output:
    @p output_addr b!        \ 0x84 -> b
    lit buf a!               \ 0x00 -> a
    @+ lit 255 and           \ read count of symbols
output_1:
    dup
    if end
 
    @+ lit 255 and           \ mem[A] & 0x000000ff
 
    !b                       \ write to output
 
    lit -1 +
    output_1 ;
end:
    halt
 
overflow:
    @p output_addr b!
    lit -858993460 !b        \ error - return bytes filled 0xCC in output
    end
 
 
 
check_symbol:
    \ function to check if capitalize letter or not
    dup lit -32 +
    if space         \ if space -> update flag
    over
    if need_to_capitalize    \ if flag is 0 - capitalize, else - decapitalize
decapitalize:
    dup lit -65 +            \ decapitalize
    -if upper_than_A         \ if char is >='A'
    ret_with_1_flag ;
 
upper_than_A:
    dup lit -91 +
    -if ret_with_1_flag      \ if char > 'Z' no decaptitalize
    lit 32 +                 \ capitalize
    ret_with_1_flag ;
 
need_to_capitalize:
    dup lit -97 +
    -if upper_than_a         \ if char is >='a'
    ret_with_1_flag ;
 
upper_than_a:
    dup lit -123 +
    -if ret_with_1_flag      \ if char >'z' no capitalize
    lit -32 +
    ret_with_1_flag ;        \ else capitalize and set the flag as 1
 
space:
 \ replace flag with 0 - capitalize next letter
    over drop lit 0
    ;
 
 
ret_with_1_flag:
    lit 1                    \ flag 1 and return to code
    ;

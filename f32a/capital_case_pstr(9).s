    .data
buf:             .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
mask:            .byte  0, '___'
error:           .word  0xCCCCCCCC
len:             .byte  0
 
    .text
 
    .org 0x90
_start:
    lit 1 a!
    @p 0x80
    dup
    lit -90 + -if bigFirstL
    @p mask +
    !+ 
 
stop:
    loop
    halt
 
loop:
    a
    lit -33 + if err            \ размер
    @p 0x80
    dup
    lit -10 + if end            \ перенос строки
    dup
    lit -32 + if afterSpace     \ пробел
    dup
    lit -90 + -if stayL         \ проверяем что оно большое
    dup
    lit -65 + -if littL         \ проверяем число ли это вообще
    @p mask +
    !+ 
    loop ;
 
littL:
    lit 32 +
    @p mask +
    !+
    loop ;
 
afterSpace:
    @p mask +
    !+
    @p 0x80
    dup
    lit -90 + -if bigL      \ проверяем маленькая ли буква
    @p mask +
    !+
    loop ;
 
end:    
    a
    lit -1
    +
    dup
    @p 0x00
    lit 0xffffff00
    and
    xor
    !p 0x00
    !p len 
    drop
    @p output_addr
    b!
    lit 1 
    a!
    @p len
    print_pstr ;
 
end_print:
    drop
    ;
 
bigL:
    lit -32 +
    @p mask +
    !+
    loop ;
 
bigFirstL:
    lit -32 +
    @p mask +
    !+
    stop ;
 
stayL:
    @p mask +
    !+
    loop ;
 
print_pstr:
    dup
    if end_print 
    lit -1 +
    !p len
    @+ lit 255 and
    !p 0x84
    @p len
    print_pstr ;
 
err:
    @p error
    !p 0x84
    halt

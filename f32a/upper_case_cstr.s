    .data
buf:         .byte  '___________________________________'
buf_size:    .word  0x20
input_addr:  .word  0x80
output_addr: .word  0x84
const_to_upper:       .word  -32
finish_symbol: .word -10
const_a_symbol: .word -97
const_z_symbol: .word -122
 
 
    .text
    .org 0x88
 
_start:
    @p buf_size
    @p input_addr b!
    lit buf a!  
 
loop:
    dup
    if print_error
    lit -1 +
    @b
    dup
    @p finish_symbol +
    if end_str
    to_upper
    !+
    loop ;
 
end_str:
    lit 0x5f5f5f00
    !+
    print_buffer ;
 
 
 
print_buffer:
    @p output_addr b!
    lit buf a!  
print_symbol:    
    @+
    lit 0xFF and
    dup
    if out
    !b
    print_symbol ;
out:    
    halt 
 
print_error:
    @p output_addr b!
    lit 0xCCCCCCCC
    !b
    halt
 
to_upper:
    dup
    @p const_a_symbol +
    -if to_upper_next1
    exit ;  
to_upper_next1:
    dup
    @p const_z_symbol +
    -if exit
to_upper_next2:
    @p const_to_upper +
exit:
    ;

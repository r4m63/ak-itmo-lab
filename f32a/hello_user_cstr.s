.data
 
message_buffer:      .byte 'Hello, \0________________________'
name_query:          .byte 'What is your name?\n\0'
excl_symbol:         .word '!'
buffer_start:        .word 0x7
buffer_limit:        .word 30
line_break:          .word 0xA
io_input:            .word 0x80
io_output:           .word 0x84
 
.text
.org    0x88
 
_start:
    @p io_output b!
    lit name_query a!
    print_string 
    @p buffer_start a!
    @p io_input b!    
 
read_input:
    @b
    dup
    check_null
    dup
    @p line_break
    xor
    if add_exclamation
    store_char
    a
    dup
    @p buffer_limit xor
    if buffer_overflow
    a!
    read_input ;    
 
add_exclamation:
    @p excl_symbol
    store_char    
    lit 0x0
    store_char
 
display_buffer:
    @p io_output b!
    lit message_buffer a!
    print_string
    terminate ;    
 
buffer_overflow:
    lit 0xCCCC_CCCC
    @p    io_output a! !
terminate:
    halt    
 
check_null:
    lit -1 +
    -if return
    @p excl_symbol
    store_char
    ;
 
 
print_string:    
    @+
    lit 0xFF and
    dup
    if return
    !b
    print_string ;
 
return:
    ;    
 
store_char:
    @ lit 0xFFFFFF00 and +
    !+
    ;

    .data
 
.org             0x00
 
buffer:          .byte  '________________________________'
 
buffer_address:  .word  0x00
buffer_size:     .word  0x16
 
input_address:   .word  0x80
output_address:  .word  0x84
 
question_string: .byte  19, 'What is your name?\n'
message_prefix:  .byte  7, 'Hello, '
message_suffix:  .byte  1, '!'
    .text
    .org 0x500
 
inc:
    lit 1 +
    ;
 
dec:
    lit -1 +
    ;
 
neg:
 
    inv
    inc
    ;
 
sub:
 
    neg
    +
    ;
 
byte_crop:
 
    lit 0xFF and
    ;
 
byte_write_inc:
 
    @
    lit 0xFFFFFF00
    and
    +
    !+
 
    ;
 
str_read:
 
    @b
    dup
    lit 0xA
    sub
    if str_read_success
    byte_write_inc
    dup
    if str_read_failure
    dec
    str_read ;
 
str_read_failure:
 
    drop
    lit -1
    ;
 
str_read_success:
 
    drop
    lit 0
    ;
 
 
pstr_concat:
 
    dup
    b!
    @b
    byte_crop
 
    @
    +
 
    @
    byte_crop
    over
    !+
 
    a
    +
    over
    a!
 
    @+
    byte_crop
 
pstr_concat_loop:
 
    dup
    if pstr_concat_end
 
    dec
    over
 
    @+
    byte_crop
 
    over
    a
 
    over
    a!
 
    over
    byte_write_inc
 
    a
    over
 
    a!
    over
 
    pstr_concat_loop ;
 
pstr_concat_end:
 
    drop
    drop
    ;
 
 
pstr_print:
 
    @+
    byte_crop
 
pstr_print_loop:
 
    dup
    if pstr_print_end
 
    dec
    @+
    byte_crop
    !b
 
    pstr_print_loop ;
 
pstr_print_end:
 
    drop
    ;
 
 
_start:
 
    lit question_string
    a!
 
    @p output_address
    b!
 
    pstr_print
 
    @p buffer_address
    a!
 
    lit 0
    byte_write_inc
 
    @p buffer_address
    a!
 
    lit message_prefix
 
    pstr_concat
 
    @p buffer_address
    dup
    a!
    inc
 
    @
    byte_crop
    +
    a!
 
    @p input_address
    b!
 
    @p buffer_size
 
    str_read
 
    -if successful_read
 
    @p output_address
    b!
 
    lit 0xCCCCCCCC
    !b
 
    halt
 
successful_read:
 
    @p buffer_size
    over
    sub
    @p buffer_address
    a!
    @
    +
    !
    lit message_suffix
    pstr_concat
    @p buffer_address
    a!
    @p output_address
    b!
    pstr_print
    halt

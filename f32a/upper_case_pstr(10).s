.data
 
buf:              .byte '________________________________'
save_zone:        .word  0x00
output_addr:      .word  0x84
input_addr:       .word  0x80
 
 
.org 150
    .text  
 
_start:
    initialize
    lit 0
    a!
while:
    input_char
    validate_length
    upper_character
    lit 0x5F5F5F00
    xor
    !
    while ;
 
    success_end
 
 
 
initialize:
    lit 8
    lit 1
    a!
init_while:
    dup 
    if init_end
    lit -1 +
    lit 0x5f5f5f5f
    !
    a lit 4 + a!
    init_while ;
init_end:
    ;
 
 
 
input_char:
    @p input_addr b! @b  
    dup
    lit 0x0000000a
    xor
    if success_end
    a
    lit 0x01
    +
    a!
    ;
 
 
 
validate_length:
    a
    lit -32 +
    -if error_end
    ;
 
 
 
upper_character:
    dup
    revert_top_value
    lit 96 +
    -if upper_character_skip
 
    dup
    lit -123 +
    -if upper_character_skip
 
    lit -32 +
 
upper_character_skip:
    ;
 
 
 
revert_top_value:
    inv
    lit 1 +
    ;
 
 
 
error_end:
    lit 0xCCCCCCCC
    @p output_addr a! !
    halt
 
 
 
success_end:
    a
    a
    @p 0
    xor
    lit 0
    a!
    !
    a!
 
    @p output_addr
    b! 
    a
    lit 1 a!
 
success_end_while_output:
    dup
    if success_end_end_porg
 
    @+ lit 255 and
 
    dup
    if success_end_end_porg
 
    !b
 
    lit -1 +
    success_end_while_output ;
 
success_end_end_porg:
    halt

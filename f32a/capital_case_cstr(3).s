.data
.org 0x0
    buf: .byte '________________________________'
    input_addr: .word 0x80
    output_addr: .word 0x84
    was_space: .word 1
    buf_size: .word 0x20
    buf_i: .word 0
 
.text
.org 0x90
_start:
    capital_case
 
    buf_to_output
    end ;
 
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
capital_case:
    lit buf a!
    @p input_addr b!
 
capital_case_do:
    @p buf_i
    lit -32 +
    if capital_case_overflow
 
    @p buf_i
    lit 1 +
    !p buf_i
 
    @b dup
    lit 10 xor
    if capital_case_end
 
    dup
    lit 32 xor
    if capital_case_space
 
    @p was_space
    lit 1 xor
    if capital_case_word_start
 
    capital_case_word ;
 
capital_case_write_buf:
 
 
capital_case_write_buf_hard:
    @
    lit 0xFFFFFF00 and
    xor
    !+
 
    ;
 
capital_case_overflow:
    r> drop
    @p output_addr b!
    lit 0xCCCC_CCCC !b
    end ;
 
capital_case_word_start:
    lit 0
    !p was_space
 
    dup lit -97 + inv
    -if capital_case_word_start_ret
 
    dup lit -123 +
    -if capital_case_word_start_ret
 
    capital_case_to_upper ;
 
capital_case_word_start_ret:
    capital_case_write_buf
    capital_case_do ;
 
 
capital_case_word:
    dup lit -65 + inv
    -if capital_case_word_ret
 
    dup lit -91 +
    -if capital_case_word_ret
 
    capital_case_to_lower ;
 
capital_case_word_ret:
    capital_case_write_buf
    capital_case_do ;
 
capital_case_to_upper:
    lit -32 +
    capital_case_write_buf
    capital_case_do ;
 
capital_case_to_lower:
    lit 32 +
    capital_case_write_buf
    capital_case_do ;
 
capital_case_space:
    lit 1
    !p was_space
 
    capital_case_write_buf
    capital_case_do ;
 
capital_case_end:
    lit 0
    capital_case_write_buf
    drop
    ;
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
 
 
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
buf_to_output:
    lit buf a!
    @p output_addr b!
 
buf_to_output_do:
    a
    lit -32 +
    if buf_to_output_end
 
    @ lit 255 and
    lit 0 xor
    if buf_to_output_end
 
    @+ lit 255 and
    !b
 
    buf_to_output_do ;
 
buf_to_output_end:
    ;
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
end:
    halt

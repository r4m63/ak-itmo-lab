    .data
buffer:          .byte  '________________________________'
buffer_end:      .byte  '___'
    \ ; сдвиг на три байта, чтобы при записи слова в последнюю ячейку не затереть данные после буфера
buffer_size:     .word  0x20
input_addr:      .word  0x80
output_addr:     .word  0x84
newline:         .word  '\n'
overflow_code:   .word  0xCCCC_CCCC
byte_mask:       .word  0x0000_00FF
upper_bytes_mask: .word  0xFFFF_FF00
 
    .text
    .org 0x88
overflow:
    @p output_addr a!
    @p overflow_code !
    halt
 
inc:
    lit 1 +
    ;
 
_start:
    read_to_buffer
    reverse_buffer
    print_buffer
    halt
 
read_to_buffer:
    lit buffer a!            \; pointer = &buffer
    @p input_addr b!         \; a = input_addr
read_to_buffer_loop:
    a lit buffer_end xor if overflow \; pointer == &buffer_end ? => overflow
    @b                       \; stack.push(mem[input_addr])
    dup
    @p newline xor if read_to_buffer_end \; if c == '\n' => read_to_buffer_end
    !+                       \; otherwise store sym
    read_to_buffer_loop ;
read_to_buffer_end:
    lit 0x5f5f5f00 !         \; store null-term as word, not affecting near bytes
    ;
 
reverse_buffer:
    lit 0                    \; null-term
    lit buffer a!            \; pointer = &buffer
buffer_to_stack_loop:
    @+ @p byte_mask and      \; stack.push(byte buffer[i])
    dup if buffer_to_stack_end \; if c == 0 => end
    buffer_to_stack_loop ;
buffer_to_stack_end:
    drop                     \; drop null-term
stack_to_buffer:
    lit buffer a!            \; pointer = &buffer
stack_to_buffer_loop:
    dup if reverse_buffer_end \; stack.top() == 0 ? => end
    @ @p upper_bytes_mask and + \; merge current sym with bytes from buffer
    !+
    stack_to_buffer_loop ;
reverse_buffer_end:
    drop                     \; drop null-term
    @ @p upper_bytes_mask and ! \; store correct null-term
    ;
 
print_buffer:
    lit buffer a!            \; a = &buffer
    @p output_addr b!        \; b = output_addr
print_buffer_loop:
    @+ @p byte_mask and      \; stack.push(buffer[i++])
    dup if print_buffer_end  \; if c == 0 => end
    !b                       \; print sym
    print_buffer_loop ;
print_buffer_end:
    drop                     \; drop null-term
    ;

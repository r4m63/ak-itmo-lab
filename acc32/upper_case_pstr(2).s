    .data
 
str_len:            .byte  0
buf:                .byte  '___________________________________'
buf_size:           .word  0x20
 
input_addr:         .word  0x80
output_addr:        .word  0x84
 
symbol_counter:     .word  0
buf_ptr:            .word  0
 
buf_mask:           .word  0x5F5F5F00
overflow_sign:      .word  0xCCCCCCCC
const_0:            .word  0
const_1:            .word  1
const_FF:           .word  0xFF
const_newline:      .word  0x0A
const_ascii_a:      .word  0x61
upper_case_offset:  .word  0x20
 
    .text
    .org 0x88
 
_start:
read_line:
    load_imm     buf                    ; acc = &buf
    store        buf_ptr                ; buf_ptr = acc
 
    load         buf_size               ; acc = *buf_size
 
while_read_line:
    beqz         overflow
 
    load_ind     input_addr             ; acc = mem[mem[input_addr]] (**input_addr)
 
    sub          const_newline          ; if (symbol == '\n') ==> output_buf
    beqz         output_buf
    add          const_newline
 
check_if_space_or_upper:
    sub          const_ascii_a          ; if (symbol < 'a') ==> skip_symbol
    ble          skip_symbol
 
raise_upper_case:                       ; else {
    add          const_ascii_a          ;   symbol += 'a'
    sub          upper_case_offset      ;   symbol -= 0x20 === raise to upper case
    jmp          write_symbol_to_buf    ;   goto write_symbol_to_buf
                                        ; }
skip_symbol:
    add          const_ascii_a
 
write_symbol_to_buf:
    or           buf_mask
    store_ind    buf_ptr                ; mem[mem[buf_ptr]] = symbol
 
    load         buf_ptr                ; buf_ptr++
    add          const_1
    store        buf_ptr
 
    load         symbol_counter         ; symbol_counter++
    add          const_1
    store        symbol_counter
 
update_buf_size:
    load         buf_size               ; buf_size--
    sub          const_1
    store        buf_size
 
    jmp          while_read_line
 
overflow:
    load_imm     buf                    ; acc = &buf
    store        buf_ptr                ; buf_ptr = acc
 
    load         overflow_sign          ; acc = overflow_sign
    store_ind    output_addr            ; mem[mem[output_addr]] = acc
 
    jmp          end
 
output_buf:
    load_imm     buf                    ; acc = &buf
    store        buf_ptr                ; buf_ptr = acc
 
    load         symbol_counter         ; acc = symbol_counter
    or           str_len                ; acc |= str_len (to get 3/4 bytes of string start)
    store        str_len                ; str_len = acc
 
while_output_buf:
    beqz         end                    ; while (symbol_counter != 0) {
 
    load_ind     buf_ptr                ;   acc = mem[mem[buf_ptr]]
    and          const_FF               ;   acc &= 0xFF
    store_ind    output_addr            ;   mem[mem[output_addr]] = acc
 
    load         buf_ptr                ;   buf_ptr++
    add          const_1
    store        buf_ptr
 
    load         symbol_counter         ;   symbol_counter--
    sub          const_1
    store        symbol_counter
 
    jmp          while_output_buf
                                        ; }
end:
    halt

    .data
 
buffer:          .byte  0x00, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F, 0x5F
len_ptr:         .word  0x0
buffer_ptr:      .word  0x1
enter:           .word  0x0A
space:           .word  0x20
upper_a:         .word  0x41
lower_a:         .word  0x60
lower_z:         .word  0x7A
diff_capital:    .word  0x20
max_size:        .word  0x20
default:         .word  0x5f
default_full:    .word  0x5F5F5F00
overflow_val:    .word  0xCCCCCCCC
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
const_1:         .word  1
const_4:         .word  4
const_FF:        .word  0xFF
const_8:         .word  0x8
const_0:         .word  0x0
 
temp_word:       .word  0x0
len:             .word  0x0
i:               .word  0x0
flag_new_word:   .word  0x1
 
    .text
 
_start:
    .org         0x88
 
process_input_word:
    load_ind     input_addr
    store        temp_word
 
    sub          enter
    beqz         capital
 
    load         len
    add          const_1
    store        len
 
    sub          max_size
    beqz         overflow
 
    ; buffer[i] <- input[i]
    load         default_full
    add          temp_word
    store_ind    buffer_ptr
 
    load         buffer_ptr
    add          const_1
    store        buffer_ptr
 
    jmp          process_input_word
 
capital:
    load_ind     len_ptr
    add          len
    store_ind    len_ptr
 
    load         buffer_ptr
    and          const_0
    add          const_1
    store        buffer_ptr
 
capital_while:
    load         len
    beqz         output
 
    load         flag_new_word
    beqz         check_space
 
    load         flag_new_word
    and          const_0
    store        flag_new_word
 
    load_ind     buffer_ptr
    and          const_FF
    sub          lower_a
    ble          next
 
    load_ind     buffer_ptr
    and          const_FF
    sub          lower_z
    bgt          next
 
    load_ind     buffer_ptr
    sub          diff_capital
    store_ind    buffer_ptr
 
    jmp          next
 
check_space:
    load_ind     buffer_ptr
    and          const_FF
    sub          space
    bnez         check_upper
    load         const_1
    store        flag_new_word
    jmp          next
 
check_upper:
    load_ind     buffer_ptr
    and          const_FF
    sub          lower_a
    bgt          next
check_minimum:
    load_ind     buffer_ptr
    and          const_FF
    sub          upper_a
    ble          next
 
    load_ind     buffer_ptr
    add          diff_capital
    store_ind    buffer_ptr
    jmp          next
 
next:
    load         buffer_ptr
    add          const_1
    store        buffer_ptr
 
    load         len
    sub          const_1
    store        len
 
    jmp          capital_while
 
output:
    load         buffer_ptr
    and          const_0
    add          const_1
    store        buffer_ptr
 
    load         i
    and          const_0
    add          max_size
    store        i
 
output_while:
    load         i
    beqz         end
 
    load_ind     buffer_ptr
    and          const_FF
    store        temp_word
 
    sub          default
    beqz         end
 
    load         temp_word
    store_ind    output_addr
 
    load         buffer_ptr
    add          const_1
    store        buffer_ptr
 
    load         i
    sub          const_1
    store        i
 
    jmp          output_while
 
end:
    halt
 
overflow:
    load         overflow_val
    store_ind    output_addr
 
    jmp          end

    .data
 
result_buff:     .byte  '________________________________'
stdin_port:      .word  0x80
stdout_port:     .word  0x84
buf_base:        .word  0x100
 
const_FF:        .word  0xFF
newline:         .word  0x0A
const_1:         .word  1
zero:            .word  0
buffer_size:     .word  0x20
 
len:             .word  0
ch:              .word  0
tmp:             .word  0
current:         .word  0
j:               .word  0
start:           .word  0
 
    .text
    .org         0x130
 
_start:
    load         buf_base
    store        tmp
 
read_loop:
    load_addr    len
    sub          buffer_size
    beqz         overflow
 
    load_ind     stdin_port
    and          const_FF
    store        ch
 
    sub          newline
    beqz         found_newline
 
    load         ch
    store_ind    tmp
 
    load         tmp
    add          const_1
    store        tmp
 
    load         len
    add          const_1
    store        len
 
    load         ch
    add          start
    beqz         found_zero
 
    jmp          read_loop
 
found_zero:
    load         len
    add          buf_base
    sub          const_1
    sub          const_1
    store        start
 
    jmp          read_loop
 
found_newline:
    load_imm     result_buff
    store        j
 
    load         start
    bnez         reverse_with_zero_found
 
    load         buf_base
    add          len
    sub          const_1
    store        current
 
    jmp          reverse_loop
 
reverse_with_zero_found:
    load         start
    store        current
 
    jmp          reverse_loop
 
reverse_loop:
    ; ������ ��ॢ���⮩ ��ப� � १������騩 �����
    load         current
    sub          buf_base
    add          const_1
    beqz         done_first
 
    load         j
    sub          len
    beqz         done_reverse
 
    load_ind     current
    and          const_FF
    store_ind    j
 
    load         current
    sub          const_1
    store        current
 
    load         j
    add          const_1
    store        j
 
    jmp          reverse_loop
 
done_first:
    load         start
    add          const_1
    store        current
 
reverse_loop_after:
    load         j
    sub          len
    beqz         done_reverse
 
    load_ind     current
    and          const_FF
    store_ind    j
 
    load         current
    add          const_1
    store        current
 
    load         j
    add          const_1
    store        j
 
    jmp          reverse_loop_after
 
done_reverse:
    load         zero
    store_ind    j
 
    load         j
    add          const_1
    store        j
 
    load_imm     0x5f5f5f5f
    store_ind    j
 
    load_imm     result_buff
    store        j
 
print_loop:
    load_ind     j
    and          const_FF
    beqz         print_done
    store_ind    stdout_port
 
    load         j
    add          const_1
    store        j
 
    jmp          print_loop
 
print_done:
    halt
 
overflow:
    load_imm     0xCCCC_CCCC
    store_ind    stdout_port
 
    halt

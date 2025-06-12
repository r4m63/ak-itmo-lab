    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
n:               .word  0x00
result:          .word  0x00
const_1:         .word  0x01
iters_count:     .word  32
 
    .text
 
_start:
    load_ind     input_addr
    store_addr   n
 
    load_addr    iters_count
 
count_while:
    beqz         count_end
 
    load_addr    n
    and          const_1
    bnez         skip_add
 
    load_addr    result
    add          const_1
    store_addr   result
 
skip_add:
    load_addr    n
    shiftr       const_1
    store_addr   n
 
    load         iters_count
    sub          const_1
    store_addr   iters_count
 
    jmp          count_while
 
count_end:
    load         result
    store_ind    output_addr
 
    halt

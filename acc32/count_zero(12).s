    .data
 
input_addr:     .word  0x80
output_addr:    .word  0x84
binary_number:  .word  0x00
counter:        .word  0x00
const_1:        .word  0x01
mask:           .word  0x01
limit:          .word  31
i:              .word 0x00 
 
    .text
 
_start:
    load_ind    input_addr
    store       binary_number
 
loop:
    load        i
    sub         limit
    bgt         end
    load        binary_number
    and         mask
    bnez        after_or_skip_inc
    load        counter
    add         const_1
    store       counter
 
after_or_skip_inc:
    load        mask
    shiftl      const_1
    store       mask
    load        i
    add         const_1
    store       i
    jmp loop
 
end:
    load        counter
    store_ind   output_addr
    halt

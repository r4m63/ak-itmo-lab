.data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
n:               .word  0x00 
const_one:       .word  0x01
const_two:       .word  0x02 
 
    .text
 
_start:
    load_ind     input_addr   
    store_addr   n 
 
check_correct:
    bgt          action
    load_imm     -1
    store_ind    output_addr
    halt
 
action:
    load_addr    n
    add          const_one
    shiftr       const_one
    clv
    store_addr   n
    mul          n
    bvs          overflow
    store_ind    output_addr
    halt
 
overflow:
    load_imm     0xCCCCCCCC
    store_ind    output_addr
    halt

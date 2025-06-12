    .data
 
input_addr:   .word  0x80
output_addr:  .word  0x84
n:            .word  0x00
const_1:      .word  0x01
i:            .word  0x02
const_1_neg:  .word  -1
 
    .text
    .org 0x88
_start:
    load_ind    input_addr
    ble         return_invalid
    beqz        return_invalid
 
init:
    store       n
    sub         const_1
    beqz        return_zero
 
    load_imm    2
    store       i
 
loop:
    load        n
    rem         i
    beqz        return_zero
 
    load        n
    div         i
    sub         i
    bgt         continue_loop
    jmp         return_one
 
continue_loop:
    load        i
    add         const_1
    store       i
    jmp         loop
 
return_one:
    load_imm    1
    jmp out
 
return_invalid:
    load_imm    -1
    jmp out
 
return_zero:
    load_imm    0
    jmp out
 
return_overflow:
    load_imm    0xCCCCCCCC
 
out:
    store_ind   output_addr
    halt

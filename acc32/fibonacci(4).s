.data
    input_addr: .word 0x80
    output_addr: .word 0x84
    n: .word 0x00
    const_0: .word 0x00
    const_1: .word 0x01
    a: .word 0x00
    b: .word 0x01
    temp: .word 0x00
    i: .word 0x02
 
.text
 
_start:
    .org 0x90
 
    load_ind input_addr
    store n
 
    ble not_in_domain
 
fibonacci_begin:
    sub const_0
    beqz return_zero
 
    load n
    sub const_1
    beqz return_one
 
fibonacci_loop:
    load i
    sub n
    bgt fibonacci_end
 
    clv
    load a
    add b
    bvs fibonacci_overflow
    store temp
 
    load b
    store a
 
    load temp
    store b
 
    load i
    add const_1
    store i
 
    jmp fibonacci_loop
 
fibonacci_end:
    load b
    store_ind output_addr
    halt
 
fibonacci_overflow:
    load_imm 0xCCCC_CCCC
    store_ind output_addr
    halt
 
return_zero:
    load const_0
    store_ind output_addr
    halt
 
return_one:
    load const_1
    store_ind output_addr
    halt
 
not_in_domain:
    load_imm -1
    store_ind output_addr
    halt

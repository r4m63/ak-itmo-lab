.data
const_one:   .word 1
const_31:    .word 31
const_32:    .word 32
 
.text
_start:
 
    addi t0, zero, 0x80
    lw a0, 0(t0)              
 
 
    lui t1, %hi(const_one)
    addi t1, t1, %lo(const_one)
    lw t2, 0(t1)           
 
    lui t3, %hi(const_31)
    addi t3, t3, %lo(const_31)
    lw t4, 0(t3)             
 
    lui t5, %hi(const_32)
    addi t5, t5, %lo(const_32)
    lw t6, 0(t5)             
 
 
    and a1, a0, t2           
 
 
    addi a2, zero, 0         
    addi a3, zero, 0
    jal s0, bit_reverse_loop       
    jal s0, store_result
    halt  
 
bit_reverse_loop:
 
    and a4, a0, t2
 
 
    sub a5, t4, a2
    sll a4, a4, a5
 
 
    or a3, a3, a4
 
 
    srl a0, a0, t2
 
 
    addi a2, a2, 1
    bne a2, t6, bit_reverse_loop
 
return:
    jr s0
 
 
 
store_result:
    addi t0, zero, 0x84       
    sw a3, 0(t0)
    jr s0

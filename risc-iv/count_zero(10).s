.data
 
input_link:       .word 0x80
output_link:      .word 0x84
 
.text 
.org 0x88
 
init_stack:
    addi  sp, zero, 0x500
    jr    ra
 
_start:
 
    jal     ra, init_stack
    lui     t0, %hi(input_link)
    addi    t0, t0, %lo(input_link)
    lw      t0, 0(t0)
    lw      t1, 0(t0)
 
    addi    t2, zero, 0
    addi    a0, zero, 1
    addi    a1, zero, 1
    addi    a3, zero, 32
 
    jal     ra, bit_zero_scan
    j       store_result
 
bit_zero_scan:
    addi    sp, sp, -4
    sw      ra, 0(sp)
 
bit_loop:
    beqz    a3, return_from_bit_scan
 
    and     t3, t1, a1
    bnez    t3, skip_increment
    addi    t2, t2, 1
skip_increment:
    srl     t1, t1, a0
    addi    a3, a3, -1
    j       bit_loop
 
return_from_bit_scan:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra
 
store_result:
    lui     t0, %hi(output_link)
    addi    t0, t0, %lo(output_link)
    lw      t0, 0(t0)
    sw      t2, 0(t0)
    halt

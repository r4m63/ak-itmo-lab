.data
.org 0x90
input_marker: .word 0x80
output_marker: .word 0x84
addr_stack: .word 0x0FFC
 
.text
_start:
    lui sp, %hi(addr_stack)
    addi sp, sp, %lo(addr_stack)
    lw sp, 0(sp)
 
    lui t0, %hi(input_marker)
    addi t0, t0, %lo(input_marker)
    lw t0, 0(t0)
    lw t1, 0(t0)
 
    ble t1, zero, exit_fail
 
    mv a0, t1
    addi sp, sp, -4
    sw ra, 0(sp)
    jal ra, count_divisors
    lw ra, 0(sp)
    addi sp, sp, 4
 
    lui t0, %hi(output_marker)
    addi t0, t0, %lo(output_marker)
    lw t0, 0(t0)
    sw a0, 0(t0)
 
    halt
 
exit_fail:
    lui t0, %hi(output_marker)
    addi t0, t0, %lo(output_marker)
    lw t0, 0(t0)
    addi a0, zero, -1
    sw a0, 0(t0)
    halt
 
count_divisors:
    addi sp, sp, -16
    sw s0, 12(sp)
    sw s1, 8(sp)
    sw s2, 4(sp)
    sw ra, 0(sp)
 
    mv s0, a0
    addi s2, zero, 0
    addi s1, zero, 1
 
loop:
    rem t0, s0, s1
    bnez t0, skip
    addi s2, s2, 1
skip:
    addi s1, s1, 1
    ble s1, s0, loop
 
    mv a0, s2
 
    lw ra, 0(sp)
    lw s2, 4(sp)
    lw s1, 8(sp)
    lw s0, 12(sp)
    addi sp, sp, 16
    jr ra

    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
stack_addr:      .word  0xffc
 
    .text
    .org 0x100
 
_start:
    lui      sp, %hi(stack_addr)
    addi     sp, sp, %lo(stack_addr)
    lw       sp, 0(sp)
 
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
 
    lw       t0, 0(t0)
    lw       a0, 0(t0) ; n
 
    jal      ra, func_count_divisors
    jal      ra, func_end
 
 
 
func_validate_n:
    mv       t5, a0
    mv       a0, ra
    jal      ra, func_push
    mv       a0, t5
 
    bgt      a0, zero, validate_n_correct
 
    mv       a0, zero
    addi     a0, zero, 1
    sub      a0, zero, a0
 
    jal      ra, func_end
 
validate_n_correct:
    jal      ra, func_pop
    mv       ra, a0
    jr       ra 
 
 
 
func_count_divisors:
    mv       t5, a0
    mv       a0, ra
    jal      ra, func_push
    mv       a0, t5
 
    jal      ra, func_validate_n
    mv       t2, zero ; i
    mv       t4, zero ; cnt
 
count_divisors_while:
    addi     t2, t2, 1
    bgtu     t2, t5, count_divisors_while_end
    rem      t3, t5, t2
    bnez     t3, count_divisors_while
    addi     t4, t4, 1
    j        count_divisors_while
 
count_divisors_while_end:
    jal      ra, func_pop
    mv       ra, a0
 
    mv       a0, t4
    jr ra
 
 
 
func_push:
    sw       a0, 0(sp)
    addi     sp, sp, -4
    jr       ra
 
 
 
func_pop:
    addi     sp, sp, 4
    lw       a0, 0(sp)
    jr       ra
 
 
 
func_end:
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
    lw       t0, 0(t0)
    sw       a0, 0(t0)
    halt

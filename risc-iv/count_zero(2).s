    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
	.org 0x88
 
_start:
	addi   sp, zero, 0xFFC
 
    lui      t0, %hi(input_addr)             
    addi     t0, t0, %lo(input_addr)
	lw       t0, 0(t0)
	lw       a0, 0(t0)
 
	jal   	 ra, count_zero
 
	lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
 
    lw       t0, 0(t0)
    sw       a1, 0(t0)
 
	halt
 
 
count_zero:
	addi    sp, sp, -4
	sw      ra, 0(sp)
 
	addi    t0, zero, 0x1
	addi    t1, zero, 32
 
loop:
	jal   	ra, last_bit
	addi    t1,  t1, -1
	bnez    t1, loop
 
	addi    t1, zero, 32
	sub 	a1, t1, a1
 
	lw      ra, 0(sp)
	addi    sp, sp, 4
	jr      ra
 
last_bit:
	and     t2, a0, t0
	add     a1, t2, a1
 
	sra     a0, a0, t0
	jr      ra

	.data
 
input_addr:			.word 	0x80
output_addr:		.word 	0x84
 
	.text
	.org 0x88
count_divisors:
 
	addi	sp, sp, -4
	sw 		ra, 0(sp)
 
	lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
	lw		t0, 0(t0)
    lw      a0, 0(t0)
	mv		a2, a0
 
	addi	t4, zero, 1	
	bgt 	t4, a0, return_error_value
 
loop:	
	jal		ra, if_divisor_inc_result
 
	addi	a2, a2, -1
	bnez 	a2, loop
 
	lw		ra, 0(sp)
	addi	sp, sp, 4
return:
	jr 		ra
 
return_error_value:
	addi	a1, zero, -1
	lw		ra, 0(sp)
	addi	sp, sp, 4
    jr		ra
 
if_divisor_inc_result:
	rem 	t5, a0, a2
	bnez 	t5, return
	addi	a1, a1, 1
	jr 		ra
 
_start:
	lui 	sp,	%hi(0x1000)
	addi 	sp, sp, %lo(0x1000)
 
	jal 	ra, count_divisors
 
count_divisors_end:
	lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
	lw		t0, 0(t0)
	sw		a1, 0(t0)	
 
    halt

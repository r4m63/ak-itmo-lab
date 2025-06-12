.data
input_addr:    .word 0x80
output_addr:   .word 0x84
 
.text
.org 	0x88
_start:
    lui 	sp, %hi(0x256)
	addi	sp, sp, %lo(0x256)
 
    lui		t0, %hi(input_addr)
    addi	t0, t0, %lo(input_addr)
	lw		t0, 0(t0) 	
	lw		a0, 0(t0)  
	addi	t4,	zero, 1  
 
check_n:
	beq 	a0, zero, write_zero
	sub		t5, a0, t4		   
	beqz    t5, write_one
	bgt		zero, a0, write_minus_one
 
	jal 	ra, fibonacci
 
write_output:
	lui		t0, %hi(output_addr)
    addi	t0, t0, %lo(output_addr)
	lw		t0, 0(t0)
	sw		a1, 0(t0)	
    halt
 
 
fibonacci:
	mv		t2, zero   ; temp
	addi	t3, zero, 2  ; loop counter
	mv  	a2, zero 	 ; a
	addi 	a1,	zero, 1  ; b
 
loop:
	bgt 	t3, a0, return
 
	addi	sp, sp, -4
	sw		ra, 0(sp)
	jal		ra, fibonacci_step
	lw      ra, 0(sp)
	addi	sp, sp, 4
 
    bgt     zero, a1, write_overflow
 
	addi	t3, t3, 1
	j		loop
 
fibonacci_step:
	mv 		t2, a2
	mv      a2, a1
	add 	a1, t2, a1 		; a1 = a + b
 
return:
	jr		ra
 
write_zero:
	mv 		a1, zero
	j 		write_output
 
write_one:
	addi    a1, zero, 1
	j 		write_output
 
write_minus_one:
	addi 	a1, zero, -1
	j		write_output
 
write_overflow:
    lui		a1, %hi(0xCCCCCCCC)
    addi	a1, a1, %lo(0xCCCCCCCC)	
	j       return

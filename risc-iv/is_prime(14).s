.data
in_addr:    .word 0x80
out_addr:   .word 0x84
 
.text
.org    0x88
_start:
	lui     t0, %hi(in_addr)
    addi    t0, t0, %lo(in_addr)
	lw		t0, 0(t0) 			; 0x80	
	lw		a0, 0(t0) 			; n
 
	lui 	sp, %hi(0x192)
	addi	sp, sp, %lo(0x192)
 
	jal 	ra, is_prime
 
	write_output:
	lui		t0, %hi(out_addr)
	addi	t0, t0, %lo(out_addr)
	lw		t0, 0(t0)		; 0x84
	sw		a1, 0(t0)
 
    halt
 
 
is_prime:
	addi	a2, zero, 1			; quotient
	mv		a1, a0				; mean + sqrt(n) value in the end
	addi	sp, sp, -4
	sw		ra, 0(sp)
	jal		ra, calculate_sqrt
	lw		ra, 0(sp)
	addi	sp,sp, 4
 
check_n:
	addi	t5, zero, 1
	beq		a0, t5, return_not_prime
    bgt		t5, a0, incorrect_input_val
 
 
	addi	t0, zero, 2			; loop counter
 
loop:
	bgt 	t0, a1, return_prime
	rem 	t6, a0, t0
	beqz 	t6, return_not_prime
	addi 	t0, t0, 1	
	j		loop	
 
 
incorrect_input_val:
	addi	a1, zero, -1
	jr		ra
 
return_prime:
	addi	a1, zero, 1
	jr		ra
 
return_not_prime:
	mv 		a1, zero
	jr		ra
 
 
calculate_sqrt:
	addi	t5, zero, 1
calculate_sqrt_while:
	ble 	a1, a2, calculate_sqrt_end
	add 	t6, a2, a1			
	srl 	a1, t6, t5
	div		a2, a0, a1
	j		calculate_sqrt_while
 
calculate_sqrt_end:
	jr		ra

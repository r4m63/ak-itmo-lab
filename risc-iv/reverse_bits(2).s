	.data
input_addr:    .word 0x80
output_addr:   .word 0x84
 
	.text
_start:
    lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
	lw		t0, 0(t0)
	lw		a0, 0(t0)		; number
 
	jal		ra, reverse_bits
write_output:
	lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
	lw		t0, 0(t0)
	sw		a1, 0(t0)	
    halt
 
 
reverse_bits:
    lui		sp, %hi(0x256)
	addi	sp, sp, %lo(0x256) 
 
	addi	a2, zero, 1 		
	addi	t1, zero, 32
	mv		a1, zero
 
loop:
	and		a3, a0, a2
	addi	sp, sp, -4
	sw		ra, 0(sp)
	jal		ra, move_bit
	lw		ra, 0(sp)
	addi	sp,	sp, 4
 
	srl 	a0, a0, a2
	addi	t1, t1, -1
	bnez	t1, loop
	jr		ra
 
move_bit:
	sll		a1, a1, a2
	or		a1, a1, a3
	jr		ra

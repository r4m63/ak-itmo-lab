	.data
 
input_addr:    .word 0x80
output_addr:   .word 0x84
 
	.text
	.org 0x88
 
_start:
 
	lui     t0, %hi(input_addr)
	addi    t0, t0, %lo(input_addr)
	lw		t0, 0(t0)
	lw		a0, 0(t0)
 
	lui 	sp, %hi(0x1000)
	addi	sp, sp, %lo(0x1000)
 
	jal 	ra, little_to_big_endian
 
write_output:
	lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
	lw		t0, 0(t0)
	sw		a1, 0(t0)	
    halt
 
little_to_big_endian:
	addi	sp, sp, -4
	sw		ra, 0(sp)
 
 
	addi 	a2, zero, 24	; count of bits for sll
	addi	t2, zero, 8		; count of bits for srl and const_8
	addi 	t3, zero, 4		; loop counter
 
loop:
	jal		ra, move_byte
 
	sub		a2, a2, t2
	srl		a0, a0, t2
	addi	t3, t3, -1
	beqz 	t3, little_to_big_endian_return
	j       loop
 
little_to_big_endian_return:
	lw		ra, 0(sp)
	addi  	sp, sp, 4
	jr		ra
 
move_byte:
	addi	t4, zero, 0xFF
	and 	t5, a0, t4
	sll		t5, t5, a2
	add		a1, a1, t5
	jr		ra

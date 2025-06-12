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
 
	jal 	ra, little_to_big_endian
 
	lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
	lw		t0, 0(t0)
	sw		a1, 0(t0)
 
    halt
 
little_to_big_endian:
	lui 	sp, %hi(0x256)
	addi	sp, sp, %lo(0x256)
	addi 	a2, zero, 24
	lui 	a3, %hi(0xFF000000)
	addi	a3, a3, %lo(0xFF000000)
	addi	t2, zero, 8
	addi 	t3, zero, 4
 
loop:
	addi	sp, sp, -4
	sw		ra, 0(sp)
	jal		ra, shift_byte
	lw		ra, 0(sp)
	addi  	sp, sp, 4
 
	sub		a2, a2, t2
	sll		a0, a0, t2
	addi	t3, t3, -1
	beqz 	t3, return
	j       loop
 
 
shift_byte:
	and 	t5, a0, a3
	srl		t5, t5, a2
	add		a1, a1, t5
 
return:
	jr		ra

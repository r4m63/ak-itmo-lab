	.data
input_addr:    .word 0x80
output_addr:   .word 0x84
 
	.text
_start:
 
    lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
	lw		a2, 0(t0)					; a2 = 0x80
 
	lui     sp, %hi(0x256)
	addi    sp, sp, %lo(0x256)
 
	jal 	ra, sum_word_cstream
 
	lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
	lw		t0, 0(t0)
	sw		a0, 0(t0)
	sw		a1, 0(t0)
    halt
 
sum_word_cstream:
	mv		a0, zero 					; high result part
	mv		a1, zero 					; low result part 
 
while:
	lw		a3, 0(a2)
	beqz    a3, return
 
	addi	sp, sp, -4
	sw		ra, 0(sp)
	jal 	ra,	sum_with_carry_check
	lw		ra, 0(sp)
	addi	sp, sp, 4
 
	j		while
 
sum_with_carry_check:
	mv		t1, a1         				; previous low part 
	add		a1, a1, a3
	bgt 	zero, a3, return			; negative operand doesn't require a carry check
	bleu 	t1, a1, return				; old low part <= new low part
	addi 	a0, a0, 1					; old low part > new low part means carry is set		
 
return:
	jr 		ra

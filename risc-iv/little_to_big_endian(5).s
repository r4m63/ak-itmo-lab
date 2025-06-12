    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
	.org 0x88
 
_start:
	addi	 sp, zero, 0xFFC
 
    lui      t0, %hi(input_addr)             
    addi     t0, t0, %lo(input_addr)
	lw       t0, 0(t0)
	lw       a2, 0(t0)
 
	jal 	 ra, reverse
 
	lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
 
    lw       t0, 0(t0)
    sw       a0, 0(t0)
 
	halt
 
 
reverse:
	addi    sp, sp, -4
	sw 		ra, 0(sp)
 
	addi 	 t0, zero, 0xFF
	addi 	 t1, zero, 8
	addi 	 t3, zero, 4
 
loop:
	jal 	 ra, rearrange_byte
	addi	 t3,  t3, -1
	bnez	 t3, loop
 
	lw  	 ra, 0(sp)
	addi 	 sp, sp, 4
	jr 		 ra
 
rearrange_byte:
	sll      a0, a0, t1
 
	and      t2, a2, t0 
	or       a0, a0, t2
	srl		 a2, a2, t1
 
	jr		 ra

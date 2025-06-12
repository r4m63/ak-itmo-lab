	.data
buffer_pstr: 		.byte	0, '_______________________________'
input_addr: 		.word 	0x80
output_addr:		.word	0x84
 
	.text
	.org	0x88
_start:
	lui     sp, %hi(0x256)
	addi    sp, sp, %lo(0x256)
 
	lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
	lw		t0, 0(t0)
 
	lui     t1, %hi(output_addr)
    addi    t1, t1, %lo(output_addr)
	lw		t1, 0(t1)
 
	addi	t2, zero, 32		; symbols count limit
	addi 	t5, zero, 0xA
	lui     t6, %hi(buffer_pstr)
    addi    t6, t6, %lo(buffer_pstr)
	mv		s1, t6				; length ptr
	addi	t6, t6, 1
 
 
read_input_while:
	lw		t4, 0(t0)
	beq		t4, t5, read_input_end
	sb		t4, 0(t6)
	beq		t6, t2, overflow
	addi	t6, t6, 1
	j		read_input_while
 
 
 
read_input_end:
	addi	t6, t6, -1
	beqz	t6, halt_machine	; empty string
    sb 		t6, 0(s1)			; (ptr value - 1) is the same with string length
 
	mv 		a0, s1				
	addi	a0, a0, 1			; left 	pointer
	mv 		a1, t6				; right pointer
	jal 	ra, reverse_string
 
 
print_pstr_start:
    addi    t6, zero, 0xFF
	lw		t4, 0(s1)
	and		t4, t4, t6
	mv		t5, s1
	addi	t5, t5, 1	
 
print_pstr_loop:
	beqz	t4, halt_machine
	lw		t2, 0(t5)
	sb		t2, 0(t1)
	addi	t4, t4, -1
	addi	t5, t5, 1
	j       print_pstr_loop
 
 
overflow:
	lui     t6, %hi(0xCCCC_CCCC)
    addi    t6, t6, %lo(0xCCCC_CCCC)
	sw		t6, 0(t1)	
 
halt_machine:	
    halt
 
 
reverse_string:
	addi	sp, sp, -4
	sw		ra, 0(sp)
	jal 	ra,	swap_letters
	lw		ra, 0(sp)
	addi	sp, sp, 4
 
	addi	a0, a0, 1
	addi	a1, a1, -1
	bgt 	a1, a0, reverse_string
	jr		ra
 
swap_letters:
	lw		t2, 0(a0)
	lw		t3, 0(a1) 
	sb		t2, 0(a1)
	sb		t3, 0(a0)
 
	jr		ra

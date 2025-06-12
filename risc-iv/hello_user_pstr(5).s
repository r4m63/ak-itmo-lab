    .data
buffer:	    	.byte 7, 'Hello, ________________________'
first_pstr:     .byte 19, 'What is your name?\n'
input_addr:		.word 0x80
output_addr:	.word 0x84
 
    .text
    .org    0x88
_start:
	lui     sp, %hi(0x1000)                
    addi    sp, sp, %lo(0x1000)
 
	jal 	ra, hello_user_pstr
 
	halt 
 
 
 
hello_user_pstr:
    addi	sp, sp, -4				; memory for word * (-1)
	sw		ra, 0(sp)
 
	lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
	lw 	 	t0, 0(t0)			
 
	addi 	a2,	a2, 0xFF			; byte mask
 
show_first_pstr:
	lui     a0, %hi(first_pstr)
    addi    a0, a0, %lo(first_pstr)
 
	jal		ra, print_pstr
 
read_input:
	lui     t3, %hi(input_addr)
    addi    t3, t3, %lo(input_addr)
	lw 	 	t3, 0(t3)
 
	lui     t1, %hi(buffer)
    addi    t1, t1, %lo(buffer)
	mv		s1, t1					; length address
	addi	s2, s2, 30				; symbols count limit			
 
	lw		t4, 0(t1)
	and		t4, t4, a2
	add		t1, t1, t4
	addi	t1, t1, 1
 
while_input:
	lw      t2, 0(t3)		
	and 	t2, t2, a2
 
	addi 	t5, t2, -10				; compare with end of line
	beqz	t5, put_exclamation_mark 
 
	addi	t4, t4, 1
 
    sb      t2, 0(t1)
 
    addi    t1, t1, 1    
	beq 	t4, s2, buffer_overflow
 
    j 		while_input
 
put_exclamation_mark:	
	addi	t4, t4, 1
	sb 		t4, 0(s1)		
 
	addi	t2, zero, 0x21 			; exclamation mark hex ASCII-code
 
	sb		t2, 0(t1)
 
show_greetings_pstr:	
	mv		a0, s1
 
	jal		ra, print_pstr
    lw		ra, 0(sp)               ; restore ra from stack
	addi    sp, sp, 4				; restore stack pointer
	jr 		ra 
 
buffer_overflow:
	lui     t2, %hi(0xCCCC_CCCC)
    addi    t2, t2, %lo(0xCCCC_CCCC)
	sw		t2, 0(t0)
    lw		ra, 0(sp)
	addi    sp, sp, 4
	jr		ra
 
print_pstr:
	mv		t1,	a0
	lw      t4, 0(t1)		  	
	and 	t4, t4, a2	
	addi 	t1, t1, 1
 
print_while:
	beqz    t4, print_callback
	lw      t2, 0(t1)		  	
	and 	t2, t2, a2
    sb      t2, 0(t0)
    addi    t1, t1, 1
	addi    t4, t4, -1
    j 		print_while
 
print_callback:
	jr		ra

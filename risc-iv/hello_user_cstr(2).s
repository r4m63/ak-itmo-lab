    .data
hello:	    		.byte 'Hello, \0________________________'
question:     		.byte 'What is your name?\n\0'
input_addr:			.word 0x80
output_addr:		.word 0x84
overflow_value: 	.word 0xCCCCCCCC
 
    .text
.org 0x88	
_start:               
	lui     sp, %hi(0x1000)
    addi    sp, sp, %lo(0x1000)
 
	jal 	ra, hello_user_сstr
	halt 
 
output:
	mv		t0, a0
	mv 		t1, a1
while:
	lw      t2, 0(t0)		  	
	and 	t2, t2, t6
	beqz	t2, ret
    sb      t2, 0(t1)
    addi    t0, t0, 1
    j 		while
ret:
	jr		ra
 
hello_user_сstr:
	addi	sp, sp, -4
	sw		ra, 0(sp)		
 
	lui     a1, %hi(output_addr)
    addi    a1, a1, %lo(output_addr)
	lw 	 	a1, 0(a1)	
 
	addi 	t6,	zero, 0xFF	
	addi	t4, zero, '!'
 
show_question:
	lui     a0, %hi(question)
    addi    a0, a0, %lo(question)
 
	jal		ra, output
 
get_input_start:
	lui     t3, %hi(input_addr)
    addi    t3, t3, %lo(input_addr)
	lw 	 	t3, 0(t3)
 
	lui     t1, %hi(hello)
    addi    t1, t1, %lo(hello)
 
	addi	t1, t1, 7
 
input:
	lw      t2, 0(t3)		
	and 	t2, t2, t6
	bnez	t2, continue
	sb 		t4, 0(t1)
	addi 	t1, t1, 1
continue:	
	addi 	t5, t2, -10
	beqz	t5, finish_hello 
 
    sb      t2, 0(t1)
 
	addi    t1, t1, 1 
    addi 	t5, t1, -30 
    beqz	t5, handle_error
 
    j 		input
 
finish_hello:	
	sb		t4, 0(t1)
	addi	t1, t1, 1
	sb		zero, 0(t1)
 
print_hello:	
	lui     a0, %hi(hello)
    addi    a0, a0, %lo(hello)
	jal		ra, output
 
	lw		ra, 0(sp)
	addi    sp, sp, 4
	jr 		ra 
 
handle_error:
	lui     t2, %hi(overflow_value)
    addi    t2, t2, %lo(overflow_value)
    lw      t2, 0(t2)
	sw		t2, 0(a1)
 
	lw		ra, 0(sp)
	addi    sp, sp, 4
	jr		ra

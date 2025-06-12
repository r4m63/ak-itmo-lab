	.data
buffer: 			.byte	0, '_______________________________'
input_addr:			.word 	0x80
output_addr:		.word 	0x84	
 
	.text
	.org 	0x88
 
_start:
	lui			t0, %hi(input_addr)
	addi		t0, t0, %lo(input_addr)
	lw			a0, 0(t0)
 
	jal			ra, upper_case_pstr
 
	halt
 
 
upper_case_pstr:
	lui			sp, %hi(0x200)
	addi		sp, sp, %lo(0x200)
 
	lui			t6, %hi(output_addr)
	addi		t6, t6, %lo(output_addr)
	lw 			t6, 0(t6) 
 
	mv 			a1, zero	       	
	addi 		t0, zero, 32	
	addi 		t1, zero, 0xFF
	addi 		t2, zero, 10
	addi 		t3, zero, 'A'
	lui			t5, %hi(buffer)
	addi		t5, t5, %lo(buffer)
	addi		t5, t5, 1
 
 
while_input:
	lw 			a1, 0(a0)
	and			a1, a1, t1
	beq			a1, t2, put_len_in_buffer
	bgt			t3, a1, put_char_in_buffer
 
	addi 		sp, sp, -4
	sw			ra, 0(sp)
	jal 		ra, return_capital_letter
	lw			ra, 0(sp)
	addi		sp, sp, 4
 
put_char_in_buffer:
	sb			a1, 0(t5)
	beq			t5, t0, overflow
	addi		t5, t5, 1
 
	j			while_input
 
put_len_in_buffer:
	lui			t4, %hi(buffer)
	addi		t4, t4, %lo(buffer)
	addi		t5, t5, -1
	sb			t5, 0(t4)
 
print_buffer:
	lw      t2, 0(t4)		  	
	and 	t2, t2, t1	
	addi 	t4, t4, 1
 
while_buffer:
	beqz    t2, return
	lw      t3, 0(t4)		  	
	and 	t3, t3, t1
    sb      t3, 0(t6)
    addi    t4, t4, 1
	addi    t2, t2, -1
    j 		while_buffer
 
 
return_capital_letter:
	addi		t4, zero, 'Z'
	ble			a1, t4, return
	addi		a1, a1, -32
    j           return
 
overflow:	
	lui 		t1, %hi(0xCCCCCCCC)
	addi		t1, t1, %lo(0xCCCCCCCC)
 
	sw			t1, 0(t6)
 
return:
	jr			ra

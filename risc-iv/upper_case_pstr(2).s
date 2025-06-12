	.data
storage: 			.byte	0, '_______________________________'
input_addr:			.word 	0x80
output_addr:		.word 	0x84	
 
 
	.text
upper_case_pstr:
	addi 		sp, sp, -4
	sw			ra, 0(sp)
 
	lui			t1, %hi(input_addr)
	addi		t1, t1, %lo(input_addr)
	lw			t1, 0(t1)
 
	lui			t6, %hi(output_addr)
	addi		t6, t6, %lo(output_addr)
	lw 			t6, 0(t6) 	
 
	addi 		t0, zero, 32		; pointer limit
	addi 		t2, zero, 10		; new line symbol
	addi 		t3, zero, 'A'		; letter 'A' to compare with current symbol
	lui			t5, %hi(storage)
	addi		t5, t5, %lo(storage)
	mv			s1, t5				; pointer to byte with length
	addi		t5, t5, 1
 
 
read_input:
	lw 			a1, 0(t1)
	beq			a1, t2, store_length
	bgt			t3, a1, char_to_buffer
 
	jal 		ra, return_capital_letter
char_to_buffer:
	sb			a1, 0(t5)
	beq			t5, t0, overflow_error
	addi		t5, t5, 1
 
	j			read_input
 
store_length:
	addi		t5, t5, -1
	sb			t5, 0(s1)
 
print_pstr:
	addi 		t1, zero, 0xFF  	; mask one symbol
	lw      	t2, 0(s1)		  	
	and 		t2, t2, t1	
	addi 		s1, s1, 1
 
while_pstr:
	beqz    	t2, upper_case_pstr_ret
	lw      	t3, 0(s1)		  	
    sb      	t3, 0(t6)
    addi    	s1, s1, 1
	addi    	t2, t2, -1
    j 			while_pstr
 
 
overflow_error:	
	lui 		t1, %hi(0xCCCC_CCCC)
	addi		t1, t1, %lo(0xCCCC_CCCC)
 
	sw			t1, 0(t6)
 
upper_case_pstr_ret:
	lw			ra, 0(sp)
	addi		sp, sp, 4
	jr			ra
 
 
return_capital_letter:
	addi		t4, zero, 'Z'
	ble			a1, t4, return
	addi		a1, a1, -32
return:
    jr			ra
 
 
	.org 0x88
_start:
	lui			sp, %hi(0x1000)
	addi		sp, sp, %lo(0x1000)
 
	jal			ra, upper_case_pstr
	halt

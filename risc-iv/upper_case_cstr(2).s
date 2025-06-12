	.data
buffer: 			.byte	'0_______________________________'
input_addr:			.word 	0x80
output_addr:		.word 	0x84	
 
	.text
	.org 0x88
 
_start:
 
	lui			t0, %hi(input_addr)
	addi		t0, t0, %lo(input_addr)
	lw			a0, 0(t0)
 
	lui			sp, %hi(0x200)
	addi		sp, sp, %lo(0x200)
 
	jal			ra, upper_case_cstr
 
	halt
 
 
upper_case_cstr:
	lui			t6, %hi(output_addr)
	addi		t6, t6, %lo(output_addr)
	lw 			t6, 0(t6) 
 
	mv 			a1, zero	       	
	addi 		t0, zero, 32		
	addi 		t1, zero, 0xFF		
	addi 		t2, zero, 0xA		
	addi 		t3, zero, 'A'
	lui			t5, %hi(buffer)
	addi		t5, t5, %lo(buffer)
 
 
 
while:
	lw 			a1, 0(a0)
	and			a1, a1, t1
	beq			a1, t2, put_null_symbol
	bgt			t3, a1, store_char
 
	addi 		sp, sp, -4
	sw			ra, 0(sp)
	jal 		ra, get_capital_letter
	lw			ra, 0(sp)
	addi		sp, sp, 4
 
store_char:
	sb			a1, 0(t5)
	addi		t5, t5, 1
	beq			t5, t0, overflow
 
	j			while
 
put_null_symbol:
	mv			t4, zero
	sb			t4, 0(t5)
 
output_pstr:
	lui			t5, %hi(buffer)
	addi		t5, t5, %lo(buffer)
 
while_2:
	lw      t3, 0(t5)		  	
	and 	t3, t3, t1
	beqz	t3, return
    sb      t3, 0(t6)
    addi    t5, t5, 1
    j 		while_2
 
get_capital_letter:
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

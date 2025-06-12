	.data
buffer_area: 		.byte	'________________________________'
input_addr:			.word 	0x80
output_addr:		.word 	0x84	
 
	.text
	.org 0x88
 
_start:
	addi		sp, zero, %lo(0x512)
 
	lui			t0, %hi(input_addr)
	addi		t0, t0, %lo(input_addr)
	lw			a0, 0(t0)
 
	jal			ra, upper_case_cstr
	halt
 
 
return_capital:
	addi		t4, zero, 'Z'
	ble			a1, t4, return_capital_callback
	addi		a1, a1, -32
return_capital_callback:
    jr			ra
 
upper_case_cstr:
	lui			t6, %hi(output_addr)
	addi		t6, t6, %lo(output_addr)
	lw 			t6, 0(t6) 
 
	addi 		t0, zero, 32
	addi 		t1, zero, 0xFF
	addi 		t2, zero, 0xA
	addi 		t3, zero, 'A'			
	lui			t5, %hi(buffer_area)
	addi		t5, t5, %lo(buffer_area)
	mv			s0, t5
 
	addi 		sp, sp, -4
	sw			ra, 0(sp)
 
while_input:
	lw 			a1, 0(a0)
	and			a1, a1, t1
	beq			a1, t2, set_termination
	bgt			t3, a1, store_char
 
	jal 		ra, return_capital
 
store_char:
	sb			a1, 0(t5)
	addi		t5, t5, 1
	beq			t5, t0, overflow
 
	j			while_input
 
set_termination:
	sb			zero, 0(t5)
 
	mv			t5, s0
 
print_loop:
	lw      	t3, 0(t5)		  	
	and 		t3, t3, t1
	beqz		t3, ret
    sb      	t3, 0(t6)
    addi    	t5, t5, 1
    j 			print_loop
 
overflow:	
	lui 		t1, %hi(0xCCCCCCCC)
	addi		t1, t1, %lo(0xCCCCCCCC)
	sw			t1, 0(t6)
ret:
	lw			ra, 0(sp)
	addi		sp, sp, 4
	jr			ra

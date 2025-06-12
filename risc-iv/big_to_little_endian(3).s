    .data
 
input_addr:      .word  0x80               ; Input address where the number 'n' is stored
output_addr:     .word  0x84               ; Output address where the result should be stored
    .text
 
_start:
    	lui	t0, %hi(input_addr)             
    	addi	t0, t0, %lo(input_addr)      
 
    	lw	t0, 0(t0)                      
 
    	lw	t2, 0(t0)                     
 
	addi 	t3, zero, 32		;	right shift for getting a necessary byte
	addi 	t5, zero, 255		;	mask for one byte
	addi 	t6, zero, 0		;	left shift for right position of the byte
 
convert_big_to_little_endian:
 
	addi	t3, t3, -8	
 
	srl	t4, t2, t3		
	and	t4, t4, t5		;	getting a necessary byte	
	sll	t4, t4, t6		;	set a necessary left shift
 
	add	t1, t1, t4
	addi	t6, t6, 8
	bnez 	t3, convert_big_to_little_endian
 
end:
	lui	t0, %hi(output_addr)
	addi	t0, t0, %lo(output_addr) 
	lw 	t0, 0(t0)
 
	sw	t1, 0(t0)
 
	halt

.data
    in_addr:       .word 0x80
    out_addr:      .word 0x84
    bit_mask:      .word 0x00000001
    loop_count:    .word 32
 
.text
.org 0x88
_start:
	lui sp, %hi(0x256)
	addi sp, sp, %lo(0x256)
 
	lui t0, %hi(in_addr)
    addi t0, t0, %lo(in_addr)
    lw t0, 0(t0)
    lw a0, 0(t0)  
 
	jal ra, reverse_bits
 
write_output:
    lui t0, %hi(out_addr)
    addi t0, t0, %lo(out_addr)
    lw t0, 0(t0)
    sw a1, 0(t0)
 
    halt
 
 
reverse_bits:    
	addi sp, sp, -4
	sw ra, 0(sp)
 
    lui a2, %hi(bit_mask)
    addi a2, a2, %lo(bit_mask)
    lw a2, 0(a2)
 
    lui t5, %hi(loop_count)
    addi t5, t5, %lo(loop_count)
    lw t5, 0(t5)
 
    addi t4, zero, 1			; bit shift const
 
    mv a1, zero					; clear result register
 
bit_reverse_loop:
    beqz t5, return
 
    sll a1, a1, t4				; shift result
	jal ra, get_bit_and_add_to_result
    srl a0, a0, t4				; shift input
 
    addi t5, t5, -1				; decrease counter
 
    j bit_reverse_loop
 
return:
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra
 
get_bit_and_add_to_result:
	and t3, a0, a2				; isolate the lowest bit
    add a1, a1, t3				; merge bit into result
	jr ra

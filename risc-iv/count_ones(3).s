.data
input_address:   .word  0x80
output_address:  .word  0x84
 
.text
_start:
	lui     sp, %hi(0x256)                
    addi    sp, sp, %lo(0x256)
 
    jal     ra, main          
    halt                   
 
main:
    addi    sp, sp, -8        
    sw      ra, 4(sp)          
 
    jal     ra, load_input    
 
    mv      t3, a0
 
    addi    t1, zero, 1
    addi    t4, zero, 1
    addi    t3, zero, 0
 
bit_count_loop:
    beqz    t1, end_count
    and     t2, a0, t1
    sll     t1, t1, t4
    beqz    t2, bit_count_loop
    addi    t3, t3, 1
    j       bit_count_loop
 
end_count:
    lui     t0, %hi(output_address)
    addi    t0, t0, %lo(output_address)
    lw      t0, 0(t0)
 
    sw      t3, 0(t0)
 
    lw      ra, 4(sp)
    addi    sp, sp, 8
    jr      ra                
 
load_input:
    lui     t0, %hi(input_address)
    addi    t0, t0, %lo(input_address)
    lw      t0, 0(t0)
 
    lw      a0, 0(t0)
 
    jr      ra

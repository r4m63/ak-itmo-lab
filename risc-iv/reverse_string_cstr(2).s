    .data
buffer:          .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
stack:           .word  0x150
 
    .text
    .org     0x200
 
_start:
    lui      s1, %hi(input_addr)
    addi     s1, s1, %lo(input_addr)
    lw       s1, 0(s1)
 
    lui      s2, %hi(buffer)
    addi     s2, s2, %lo(buffer)
    lui      sp, %hi(stack)
    addi     sp, sp, %lo(stack)
    lw       sp, 0(sp)
 
    lui      s4, %hi(output_addr)
    addi     s4, s4, %lo(output_addr)
    lw       s4, 0(s4)
 
    mv       a0, zero
    mv       a1, zero
    mv       a2, zero
 
    jal      ra, reverse_read_char_to_stack
    jal      ra, from_stack_to_buffer
    jal      ra, write_after_zero
    jal      ra, write_output
 
    halt
 
reverse_read_char_to_stack:
    mv       t4, sp
    mv       t3, zero
 
reverse_read_char_to_stack_loop:
    lw       t1, 0(s1)
    beqz     t1, reverse_read_char_to_stack_zero_found
    addi     t2, zero, 10
    beq      t1, t2, reverse_read_char_to_stack_end
    addi     t3, t3, 1
    addi     t2, zero, 32
    beq      t3, t2, reverse_read_char_to_stack_overflow
    sb       t1, 0(sp)
    addi     sp, sp, -4
    j        reverse_read_char_to_stack_loop
 
reverse_read_char_to_stack_zero_found:
    addi     a2, zero, 1
    jr       ra
 
reverse_read_char_to_stack_overflow:
    addi     a0, zero, 1
    jr       ra
 
reverse_read_char_to_stack_end:
    jr       ra
 
from_stack_to_buffer:
    mv       t5, s2
    beq      sp, t4, from_stack_to_buffer_stack_is_empty
    addi     sp, sp, 4
 
from_stack_to_buffer_loop:
    lw       t1, 0(sp)
    beqz     t1, from_stack_to_buffer_final_write
    sb       t1, 0(t5)
    beq      sp, t4, from_stack_to_buffer_final_write
    addi     sp, sp, 4
    addi     t5, t5, 1
    j        from_stack_to_buffer_loop
 
from_stack_to_buffer_stack_is_empty:
    sb       zero, 0(t5)
    addi     a1,zero,1
    jr       ra
 
from_stack_to_buffer_final_write:
    addi     t5, t5, 1
    sb       zero, 0(t5)
    jr       ra
 
write_after_zero:
    bnez     a2, write_after_zero_to_buffer
    jr       ra
 
write_after_zero_to_buffer:
    addi     t5, t5, 1
 
write_after_zero_to_buffer_loop:
    lw       t1, 0(s1)
    addi     t2, zero, 0xFF
    and      t1, t1, t2
    addi     t2, zero, 10
    beq      t1, t2, write_after_zero_to_buffer_end
    sb       t1, 0(t5)
    addi     t5, t5, 1
    j        write_after_zero_to_buffer_loop
 
write_after_zero_to_buffer_end:
    sb       zero, 0(t5)
    jr       ra
 
write_output:
    mv       t0, s2
    bnez     a0, write_output_overflow
    bnez     a1, write_output_end
 
write_output_loop:
    lw       t1, 0(t0)
    addi     t2, zero, 0xFF
    and      t1, t1, t2
    beqz     t1, write_output_end
    sb       t1, 0(s4)
    addi     t0, t0, 1
    j        write_output_loop
 
write_output_end:
    jr       ra
 
write_output_overflow:
    mv       t1, zero
    lui      t1, %hi(0xCCCCCCCC)
    addi     t1, t1, %lo(0xCCCCCCCC)
    sw       t1, 0(s4)
    j        write_output_end

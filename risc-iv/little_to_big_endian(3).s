    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
    .org 0x88
_start:
    lui sp, %hi(0x512)
    addi sp, sp, %lo(0x512)
 
    lui t0, %hi(input_addr)
    addi t0, t0, %lo(input_addr)
    lw t1, 0(t0)
    lw a0, 0(t1)
 
    jal ra, little_to_big_endian
 
    lui t0, %hi(output_addr)
    addi t0, t0, %lo(output_addr)
    lw t1, 0(t0)
    sw a0, 0(t1)
 
    halt
 
little_to_big_endian:
    addi t5, zero, 0xFF
 
    mv t0, a0                   ; t0 = original value
    addi a0, zero, 0            ; Initialize result to 0
    addi t1, zero, 0            ; Initialize loop counter
    addi t2, zero, 4            ; Loop 4 times (for 4 bytes)
 
    addi sp, sp, -4
    sw  ra, 0(sp)
byte_swap_loop:
    beq t1, t2, byte_swap_done  ; Exit loop when counter reaches 4
 
    and t3, t0, t5              ; Extract current byte
 
    mv a2, t1
    jal ra, calculate_shift_amount
 
    sll t3, t3, a1              ; Shift byte to its new position
    or a0, a0, t3               ; Add byte to result
 
    addi a1, zero, 8
    srl t0, t0, a1              ; Shift original value right by 8 bits
    addi t1, t1, 1              ; Increment counter
    j byte_swap_loop
 
byte_swap_done:
    lw  ra, 0(sp)
    addi sp, sp, 4
    jr ra
 
calculate_shift_amount:
    addi a1, zero, 3       
    sub a1, a1, a2              ; Calculate shift amount (3-i)*8
    addi t4, zero, 8
    mul a1, a1, t4              ; t6 = (3-i)*8
    jr ra

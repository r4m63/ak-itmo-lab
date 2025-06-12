    .data
buffer:          .byte  '________________________________'
buffer_length:   .word  0x20
 
newline_char:    .word  0x0000000A
overflow_value:  .word  0xCCCCCCCC
mask_byte:       .word  0x000000FF
to_upper_mask:   .word  0x000000DF
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
 
 
    .text
    .org     0x88
_start:
    ; a0 - buffer
    ; a1 - buffer_size
    ; a2 - string size counter
    ; a3 - new line char ('\n')
    ; a4 - mask_byte
    ; a5 - to_upper_mask
    ; a6 - tmp
    ; t0 - readed word
    ; t1 - tmp
    ; t2 - address
    ; t3 - tmp
 
 
    ; initialize stack pointer
    addi     sp, zero, 120
 
    ; a0 = (buffer)&
    lui      a0, %hi(buffer)
    addi     a0, a0, %lo(buffer)
 
    ; a1 = buffer_length
    lui      a1, %hi(buffer_length)
    addi     a1, a1, %lo(buffer_length)
    lw       a1, 0(a1)
 
    ; Initialize string size counter
    mv       a2, zero
 
    ; a3 = '\n'
    lui      a3, %hi(newline_char)
    addi     a3, a3, %lo(newline_char)
    lw       a3, 0(a3)
 
    ; a4 = mask_byte
    lui      a4, %hi(mask_byte)
    addi     a4, a4, %lo(mask_byte)
    lw       a4, 0(a4)
 
    ; a5 = to_upper_mask
    lui      a5, %hi(to_upper_mask)
    addi     a5, a5, %lo(to_upper_mask)
    lw       a5, 0(a5)
 
    addi     sp, sp, -4
    sw       ra, 0(sp)
    jal      ra, readline
    lw       ra, 0(sp)
    addi     sp, sp, 4
 
    beq      a2, a1, push_overflow
 
    addi     sp, sp, -4
    sw       ra, 0(sp)
    jal      ra, write
    lw       ra, 0(sp)
    addi     sp, sp, 4
 
    j exit
 
push_overflow:
    lui      t0, %hi(overflow_value)
    addi     t0, t0, %lo(overflow_value)
    lw       t0, 0(t0)
 
    lui      t2, %hi(output_addr)
    addi     t2, t2, %lo(output_addr)
    lw       t2, 0(t2)
 
    sw       t0, 0(t2)
 
exit:
    halt
 
 
readline:
    lui      t2, %hi(input_addr)
    addi     t2, t2, %lo(input_addr)
    lw       t2, 0(t2)
 
readline_loop:
    lw       t0, 0(t2)
    and      t0, t0, a4
 
    add      t1, a0, a2
    beq      t0, a3, read_end
 
    addi     sp, sp, -4
    sw       ra, 0(sp)
    mv       a6, t0
    jal      ra, to_upper_case
    lw       ra, 0(sp)
    addi     sp, sp, 4
    mv       t0, a6
 
 
    addi     a2, a2, 1
 
    sb       t0, 0(t1)
    bne      a1, a2, readline_loop
 
    add      t1, a0, a2
 
read_end:
    sb       zero, 0(t1)
    jr       ra
 
 
to_upper_case:
    ; a6 - char to upper
 
    addi     t3, zero, 'Z'
    ble      a6, t3, to_upper_case_end
 
    addi     t3, zero, 'z'
    bgt      a6, t3, to_upper_case_end
 
    and      a6, a6, a5
 
to_upper_case_end:
    jr       ra
 
 
write:
    mv       t1, a0
 
    lui      t2, %hi(output_addr)
    addi     t2, t2, %lo(output_addr)
    lw       t2, 0(t2)
 
 
write_loop:
    lw       t0, 0(t1)
    and      t0, t0, a4
 
    beqz     t0, write_end
 
    sb       t0, 0(t2)
 
    addi     t1, t1, 1
 
    bnez     t3, write_loop
 
write_end:
    jr       ra

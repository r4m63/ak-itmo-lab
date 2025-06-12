    .data
buffer:          .byte  '\0_______________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
    .org     0x88
_start:
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       t0, 0(t0)                       ; t0 <- input_addr
 
    lui      t1, %hi(output_addr)
    addi     t1, t1, %lo(output_addr)
    lw       t1, 0(t1)                       ; t1 <- output_addr
 
    lui      sp, %hi(0x200)
    addi     sp, sp, %lo(0x200)              ; initialize stack
 
    addi     t2, zero, 31                    ; max buffer size
    addi     a2, zero, 0xFF                  ; a2 <- mask
    addi     t5, zero, 10                    ; t5 <- '\n'
    lui      t6, %hi(buffer)
    addi     t6, t6, %lo(buffer)
    mv       s1, t6                          ; s1 <- buffer addr
 
read_input_loop:
    lw       t4, 0(t0)
    and      t4, t4, a2                      ; t4 <- lowest byte of input
    beqz     t4, save_right                  ; if input byte == '\0' => end of str
continue:
    beq      t4, t5, read_input_end          ; if input bute == '\n' => end of str
    sb       t4, 0(t6)                       ; buffer <- input byte
    beq      t6, t2, overflow
    addi     t6, t6, 1
    j        read_input_loop
 
save_right:
    mv       s2, t6
    addi     s2, s2, -1                      ; s2 points to the last input byte
    j        continue
 
 
read_input_end:
    beqz     t6, stop
    sb       zero, 0(t6)                     ; buffer <- '\0'
 
    mv       a0, s1                          ; a0 <- start of buffer
    mv       a1, s2                          ; a1 <- end of buffer
    bnez     a1, call_reverse_string
    mv       a1, t6                          ; if a1 == 0 then no '\0' were met
    addi     a1, a1, -1
call_reverse_string:
    jal      ra, reverse_string
 
 
write_output_buffer:
    mv       t5, s1
 
loop:
    lw       t2, 0(t5)
    and      t2, t2, a2
    beqz     t2, stop
    sb       t2, 0(t1)
    addi     t5, t5, 1
    j        loop
 
 
overflow:
    lui      t6, %hi(0xCCCC_CCCC)
    addi     t6, t6, %lo(0xCCCC_CCCC)
    sw       t6, 0(t1)
 
stop:
    halt
 
 
reverse_string:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    jal      ra, swap_chars_in_buffer
    lw       ra, 0(sp)
    addi     sp, sp, 4
 
    addi     a0, a0, 1
    addi     a1, a1, -1
    bgt      a1, a0, reverse_string          ; if a1 <= a0 then need more swaps
    jr       ra
 
swap_chars_in_buffer:
    lw       t2, 0(a0)
    and      t2, t2, a2                      ; t2 <- lowest byte of left pointer
    lw       t3, 0(a1)
    and      t3, t3, a2                      ; t3 <- lowest byte of right pointer
    sb       t2, 0(a1)                       ; a1 <- t2
    sb       t3, 0(a0)                       ; a0 <- t3
 
    jr       ra

    .data
buffer:          .byte  0, '_______________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
 
STACK_SIZE:      .word  0x300
 
    .text
    .org     0x88
 
_start:
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       a0, 0(t0)
    jal      ra, process_text
 
halt_machine:
    halt
 
process_text:
    lui      sp, %hi(STACK_SIZE)
    addi     sp, sp, %lo(STACK_SIZE)
 
    lui      t1, %hi(buffer)
    addi     t1, t1, %lo(buffer)
    mv       s2, t1
    addi     t1, t1, 1
    lui      t2, %hi(output_addr)
    addi     t2, t2, %lo(output_addr)
    lw       t2, 0(t2)
 
    addi     t0, zero, 32                    ; BUFFER_SIZE
    addi     t4, zero, 0x41                  ; ASCII_A
    addi     t5, zero, 0xFF                  ; BYTE_MASK
    addi     t6, zero, 0xA                   ; ASCII_NL
 
input_loop:
    lw       a1, 0(a0)
    and      a1, a1, t5
    beq      a1, t6, store_length
    bgt      t4, a1, save_char
    addi     sp, sp, -4
    sw       ra, 0(sp)
    jal      ra, transform_char
    lw       ra, 0(sp)
    addi     sp, sp, 4
 
save_char:
    sb       a1, 0(t1)
    beq      t1, t0, buffer_overflow
    addi     t1, t1, 1
    j        input_loop
 
store_length:
    addi     t1, t1, -1
    sb       t1, 0(s2)
 
output_data:
    lw       t6, 0(s2)
    and      t6, t6, t5
    mv       t3, s2
    addi     t3, t3, 1
 
output_loop:
    beqz     t6, done
    lw       t4, 0(t3)
    and      t4, t4, t5
    sb       t4, 0(t2)
    addi     t3, t3, 1
    addi     t6, t6, -1
    j        output_loop
 
transform_char:
    addi     t3, zero, 0x5A                  ; ASCII_Z
    ble      a1, t3, done
    addi     a1, a1, -32                     ; ASCII_DIFF
    j        done
 
buffer_overflow:
    lui      t5, %hi(0xCCCCCCCC)
    addi     t5, t5, %lo(0xCCCCCCCC)
    sw       t5, 0(t2)
 
done:
    jr       ra

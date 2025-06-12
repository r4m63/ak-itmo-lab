.data
buffer:            .byte   7, 'Hello, ', 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f, 0x5f
question:          .byte   19, 'What is your name?\n'
input:             .word   0x80
output:            .word   0x84
overflow_marker:   .word   0xCCCCCCCC
 
.text
.org 0x88
_start:
    lui     sp, %hi(0x200)                ; Initialize stack pointer
    addi    sp, sp, %lo(0x200)
    jal     ra, hello_user_pstr
    halt
 
hello_user_pstr:
    addi    sp, sp, -12
    sw      ra, 0(sp)
    sw      s0, 4(sp)                     ; Save s0 for output port address
    sw      s1, 8(sp)                     ; Save s1 for buffer base address
 
    addi    t6, zero, 0xFF                ; Mask for byte operations
 
    ; Load output port address
    lui     s0, %hi(output)
    addi    s0, s0, %lo(output)
    lw      t0, 0(s0)
 
    ; Print question
    lui     a0, %hi(question)
    addi    a0, a0, %lo(question)
    jal     ra, output_pstring
 
    ; Load input port and buffer addresses
    lui     t0, %hi(input)
    addi    t0, t0, %lo(input)
    lw      t3, 0(t0)                     ; Input port address
 
    lui     t1, %hi(buffer)
    addi    t1, t1, %lo(buffer)
    mv      s1, t1                        ; Save buffer base for length update
    addi    t1, t1, 8                     ; Point to after "Hello, "
    mv      s2, t1                        ; Save pointer for input
 
    ; Read input loop (max 23 chars to allow for '!')
    addi    t5, zero, 23                  ; Max input length before '!'
    mv      s3, zero                      ; Input character count
 
input_loop:
    lw      t2, 0(t3)                     ; Read input byte
    and     t2, t2, t6                    ; Mask to byte
    addi    t0, t2, -10                   ; Check for newline
    beqz    t0, input_done                ; Exit on newline
    addi    t0, t2, -13                   ; Check for carriage return
    beqz    t0, input_loop                ; Skip carriage return
    addi    t0, s3, 1                     ; Check next count
    beq     t0, t5, handle_overflow       ; Jump if next char would be 23rd
    sb      t2, 0(t1)                     ; Store input byte
    addi    t1, t1, 1                     ; Increment buffer pointer
    addi    s3, s3, 1                     ; Increment input count
    j       input_loop
 
input_done:
    ; Store exclamation mark
    addi    t2, zero, '!'
    sb      t2, 0(t1)
 
    ; Update length byte
    mv      t4, s3
    addi    t4, t4, 8                     ; Length = input + 7 ("Hello, ") + 1 ("!")
    and     t4, t4, t6                    ; Mask to byte
    sb      t4, 0(s1)                     ; Store length in buffer[0]
 
    ; Reload output port address
    lw      t0, 0(s0)                     ; Use saved output port address
 
    ; Print buffer
    mv      a0, s1                        ; Start from buffer base (includes length byte)
    jal     ra, output_pstring
 
    ; Restore return address and registers
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
    jr      ra
 
handle_overflow:
    ; Output overflow marker
    lui     t2, %hi(overflow_marker)
    addi    t2, t2, %lo(overflow_marker)
    lw      t2, 0(t2)
    lw      t0, 0(s0)                     ; Use saved output port address
    sw      t2, 0(t0)
 
    ; Restore return address and registers
    lw      ra, 0(sp)
    lw      s0, 4(sp)
    lw      s1, 8(sp)
    addi    sp, sp, 12
    jr      ra
 
output_pstring:
    mv      t1, a0                        ; String address
    lw      t4, 0(t1)                     ; Load length byte
    and     t4, t4, t6                    ; Mask to byte
    addi    t1, t1, 1                     ; Point to string data
 
output_loop:
    beqz    t4, output_done               ; Exit if length is 0
    lw      t2, 0(t1)                     ; Load byte
    and     t2, t2, t6                    ; Mask to byte
    sb      t2, 0(t0)                     ; Output byte
    addi    t1, t1, 1                     ; Increment pointer
    addi    t4, t4, -1                    ; Decrement length
    j       output_loop
 
output_done:
    jr      ra

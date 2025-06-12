    .data
    .org 0x00
 
buf:             .byte  7, 'Hello, _________________________' ; len = 32
input_addr:      .word  0x80               ; name (max 24 bytes)
output_addr:     .word  0x84               ; Output address where the result should be stored
greeting:        .byte  19, 'What is your name?\n'
 
    .text
    .org 0x88
 
_start:
    lui     sp, %hi(0x1000)                
    addi    sp, sp, %lo(0x1000)
 
    jal ra, main
    halt
 
main:
    addi sp, sp, -4
    sw   ra, 0(sp)            ; сохранить адрес возврата
 
    lui  t0, %hi(input_addr)
    addi t0, t0, %lo(input_addr)
    lw   t1, 0(t0)            ; t1 = 0x80
 
    lui  t6, %hi(buf)
    addi t6, t6, %lo(buf)     ; t6 = адрес buf
 
    addi t4, zero, 10         ; символ \n
    addi a5, zero, 22         ; максимальная длина
    addi t3, zero, 0          ; счётчик = 0
 
    jal ra, read_into_buffer
 
    lw   ra, 0(sp)
    addi sp, sp, 4
    jr ra
 
read_into_buffer:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    bgt t3, a5, too_long
 
    lw  t2, 0(t1)
    beq t2, t4, after_input
 
    addi t3, t3, 1
    sb   t2, 8(t6)
    addi t6, t6, 1
    j    read_into_buffer
 
after_input:
    addi a0, zero, '!'
    sb   a0, 8(t6)
 
    addi s9, t3, 8
    lui  s2, %hi(output_addr)
    addi s2, s2, %lo(output_addr)
    lw   s2, 0(s2)
 
    jal ra, print_greeting
 
    addi s9, t3, 8
    lui  s6, %hi(buf)
    addi s6, s6, %lo(buf)
 
    sb   s9, 0(s6)
    addi s6, s6, 1
 
    jal ra, while_out
 
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
 
print_greeting:
    addi sp, sp, -4
    sw   ra, 0(sp)
 
    lui  s6, %hi(greeting)
    addi s6, s6, %lo(greeting)
    addi s6, s6, 1
    addi s8, zero, 1
    addi s9, zero, 19
 
    jal ra, while_out
 
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra
 
while_out:
    beqz s9, end_while
    sub  s9, s9, s8
    lw   s1, 0(s6)
    sb   s1, 0(s2)
    addi s6, s6, 1
    j    while_out
 
end_while:
    jr ra
 
too_long:
    addi s9, zero, 19
    jal ra, print_greeting
 
    lui  s2, %hi(output_addr)
    addi s2, s2, %lo(output_addr)
    lw   s2, 0(s2)
 
    jal  ra, print_greeting
 
    lui  a2, %hi(0xCCCCCCCC)
    addi a2, a2, %lo(0xCCCCCCCC)
    sw   a2, 0(s2)
 
    lw ra, 0(sp)
    addi sp, sp, 4
    jr ra

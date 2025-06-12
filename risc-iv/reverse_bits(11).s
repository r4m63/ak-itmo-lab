    .data
 
input_addr:      .word  0x80                     ; Адрес для ввода n
output_addr:     .word  0x84                     ; Адрес для вывода результата
 
    .text
 
_start:
    addi     sp, zero, 0x500
    addi     t1, zero, 1
 
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
 
    lw       t0, 0(t0)
    lw       a0, 0(t0)
 
    addi     a2, zero, 32
 
    jal      ra, reverse_bits
 
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
 
    lw       t0, 0(t0)
    sw       a1, 0(t0)
 
    halt
 
reverse_bits:
    addi     sp, sp, -4
    sw       ra, 0(sp)
 
    beqz     a2, end
 
    sll      a1, a1, t1
    and      t0, a0, t1
    or       a1, a1, t0
    srl      a0, a0, t1
 
    addi     a2, a2, -1
 
    jal      ra, reverse_bits
 
end:
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra

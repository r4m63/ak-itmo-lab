    .data

input_addr:      .word  0x80
output_addr:     .word  0x84
initial_stack_addr: .word  0x80

    .text
_start:
    .org     0x88

    lui      sp, %hi(initial_stack_addr)
    addi     sp, sp, %lo(initial_stack_addr)
    lw       sp, 0(sp)
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       t0, 0(t0)
    lw       t1, 0(t0)
    jal      ra, change_endianess
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
    lw       t0, 0(t0)
    sw       a0, 0(t0)
    halt

change_endianess:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    mv       a0, zero
    mv       a1, zero
    addi     a3, zero, 0xFF
    addi     a2, zero, 0x18
    jal      ra, shift_right
    addi     a2, zero, 0x8
    sll      a3, a3, a2
    jal      ra, shift_right
    sll      a3, a3, a2
    jal      ra, shift_left
    sll      a3, a3, a2
    addi     a2, zero, 0x18
    jal      ra, shift_left
    lw       ra, 0(sp)
    addi     sp, sp, 4

end:
    jr       ra

shift_right:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    srl      a1, t1, a2
    j        mask_add

shift_left:
    addi     sp, sp, -4
    sw       ra, 0(sp)
    sll      a1, t1, a2

mask_add:
    and      a1, a1, a3
    add      a0, a1, a0
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra

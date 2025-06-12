    .data

buffer_area:     .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
overflow_val:    .word  0xCCCCCCCC

    .text
    .org    0x100

_start:
    addi    sp, zero, 0x500
    lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
    lw      a0, 0(t0)
    jal     ra, upper_case_pstr
    halt

return_capital:
    addi    t4, zero, 'a'
    bgt     t4, a1, rc_exit
    addi    t4, zero, 'z'
    bgt     a1, t4, rc_exit
    addi    a1, a1, -32
rc_exit:
    jr      ra


upper_case_pstr:
    addi    sp, sp, -4
    sw      ra, 0(sp)

    lui     t2, %hi(output_addr)
    addi    t2, t2, %lo(output_addr)
    lw      t6, 0(t2)

    addi    t5, zero, 255
    addi    t2, zero, 10
    addi    t3, zero, 31

    lui     t4, %hi(buffer_area)
    addi    t4, t4, %lo(buffer_area)
    mv      s0, t4
    addi    t0, t4, 1
    addi    t1, zero, 0

    jal     ra, read_next

    sb      t1, 0(s0)

    mv      t4, t1
    addi    t0, s0, 1
print_loop:
    beqz    t4, finish
    lw      a1, 0(t0)
    and     a1, a1, t5
    sb      a1, 0(t6)
    addi    t0, t0, 1
    addi    t4, t4, -1
    j       print_loop

overflow_path:
    lui     t4, %hi(overflow_val)
    addi    t4, t4, %lo(overflow_val)
    lw      t4, 0(t4)
    sw      t4, 0(t6)
    addi    t1, zero, 0
    sb      t1, 0(s0)

finish:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra


read_next:
    addi    sp, sp, -4
    sw      ra, 0(sp)

    lw      a1, 0(a0)
    and     a1, a1, t5
    beq     a1, t2, rn_done

    beq     t1, t3, rn_overflow

    jal     ra, return_capital
    sb      a1, 0(t0)
    addi    t0, t0, 1
    addi    t1, t1, 1
    jal     ra, read_next

rn_done:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra

rn_overflow:
    lw      ra, 0(sp)
    addi    sp, sp, 4
    j       overflow_path

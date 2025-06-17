    .data

buff:            .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
stack_addr:      .word  0x280


    .text
    .org 0x92

    ; s1 -- '\n' code
    ; s2 -- 0xFF mask
    ; s3 -- max buff size
    ; s4 -- '\0' code

    ; a1 -- buffer start
    ; a2 -- buffer end

    ; t0 -- input_addr
    ; t1 -- output_addr
    ; t2 -- buff_ptr
    ; t3 -- temp for reading
    ; t4 -- left swap pointer
    ; t5 -- right swap pointer
    ; t6 -- output write pointer

_start:
    ; input_addr
    lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
    lw      t0, 0(t0)

    ; output_addr
    lui     t1, %hi(output_addr)
    addi    t1, t1, %lo(output_addr)
    lw      t1, 0(t1)

    ; set up constants
    addi    s1, zero, 10
    addi    s2, zero, 0xFF
    addi    s3, zero, 31
    addi    s4, zero, 0

    ; buffer address
    lui     t2, %hi(buff)
    addi    t2, t2, %lo(buff)
    mv      a1, t2
    mv      t6, a1

    ; stack initialization
    lui     sp, %hi(stack_addr)
    addi    sp, sp, %lo(stack_addr)


read_while:
    lw      t3, 0(t0)
    and     t3, t3, s2
    beqz    t3, found_null
    ; beq     t3, s4, read_end

read_continue:
    beq     t3, s1, read_end
    sb      t3, 0(t2)
    beq     t2, s3, overflow
    addi    t2, t2, 1
    j       read_while

not_found_null:
    j       read_end

found_null:
    mv      a2, t2
    addi    a2, a2, -1
    j       read_continue

read_end:
    sb      zero, 0(t2)
    beqz    t2, end

    bnez    a2, read_jump
    mv      a2, t2
    beq     a1, a2, end
    addi    a2, a2, -1
    beq     a1, a2, write_while

read_jump:
    j       reverse_while


write_while:
    lw      t3, 0(t6)
    and     t3, t3, s2
    beqz    t3, end
    sb      t3, 0(t1)
    addi    t6, t6, 1
    j       write_while


reverse_while:
    addi    sp, sp, -4
    sw      ra, 0(sp)
    jal     ra, swap_letters
    lw      ra, 0(sp)
    addi    sp, sp, 4
    addi    a1, a1, 1
    addi    a2, a2, -1
    ble     a1, a2, reverse_while

reverse_end:
    j       write_while

swap_letters:
    lw      t4, 0(a1)
    lw      t5, 0(a2)
    sb      t4, 0(a2)
    sb      t5, 0(a1)
    jr      ra


overflow:
    lui      t3, %hi(0xCCCC_CCCC)
    addi     t3, t3, %lo(0xCCCC_CCCC)
    sw       t3, 0(t1)

end:
    halt

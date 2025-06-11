    .data

input_addr:      .word  0x80
output_addr:     .word  0x84
prime:           .byte  1
not_prime:       .byte  0
invalid_input:   .word  -1
loops_data:      .word  1, 0, 2

    .text

_start:
    movea.l  input_addr, A0
    movea.l  (A0), A0
    move.l   (A0)+, D0
    move.l   D0, D1
    sub.l    1, D1
    blt      invalid_end
    beq      set_not_prime
    movea.l  loops_data, A1
    move.l   D0, 4(A1)

calculate_sqrt:
    move.l   (A1), D1
    sub.l    4(A1), D1
    bge      searching_divider
    move.l   (A1), D1
    add.l    4(A1), D1
    div.l    2, D1
    move.l   D1, 4(A1)
    move.l   D0, D2
    div.l    D1, D2
    move.l   D2, (A1)
    jmp      calculate_sqrt


    .text
    .org     0x88

searching_divider:
    move.l   4(A1), D1
    move.l   D0, D2
    sub.l    8(A1), D1
    blt      set_prime
    div.l    8(A1), D2
    mul.l    8(A1), D2
    sub.l    D0, D2
    beq      set_not_prime
    add.l    1, 8(A1)
    jmp      searching_divider

set_prime:
    movea.l  prime, A1
    jmp      correct_end

set_not_prime:
    movea.l  not_prime, A1

correct_end:
    move.b   (A1), (A0)
    jmp      end

invalid_end:
    movea.l  invalid_input, A1
    move.l   (A1), (A0)

end:
    halt

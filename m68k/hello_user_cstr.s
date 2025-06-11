    .data

buf:                .byte  'Hello, ________________________________'
buf_addr:           .word  0x07
buf_size:           .word  0x16
question:           .byte  'What is your name?\n', 0x00
end_of_line:        .word  '!'
input_addr:         .word  0x80
output_addr:        .word  0x84

    .text
    .org     0x100

_start:

main_prog:
    movea.l     input_addr, A1
    movea.l     (A1), A1
    movea.l     output_addr, A6
    movea.l     (A6), A6
    move.l      question, D0

loop1:
    movea.l     D0, A0
    move.b      (A0), D1
    beq         next1
    move.l      D1, (A6)
    add.l       1, D0
    jmp         loop1


next1:
    movea.l      buf_addr, A0
    move.l       (A0), D0

buff_loop:
    move.b       (A1), D1
    beq          next_word
    move.b       D1, D3
    sub.b        0x0A, D3
    beq          next2
    move.l       D4, D4
    bmi          nxt
    movea.l      D0, A0
    move.l       D1, (A0)
    add.l        1, D0
    add.l        1, D5
    movea.l      buf_size, A5
    move.l       (A5), D6
    sub.l        D5, D6
    bmi          bad_end
    jmp nxt

next_word:
    move.l       -1, D4

nxt:
    jmp          buff_loop

next2:
    movea.l      end_of_line, A0
    move.l       (A0), D1
    movea.l      D0, A0
    move.l       D1, (A0)
    add.l        1, D0
    move.l       0x00, D1
    movea.l      D0, A0
    move.l       D1, (A0)
    add.l        1, D0
    move.l       0x5f5f5f5f, D1
    movea.l      D0, A0
    move.l       D1, (A0)
    move.l      buf, D0

loop3:
    movea.l     D0, A0
    move.b      (A0), D2
    beq         next3
    move.l      D2, (A6)
    add.l       1, D0
    jmp         loop3

next3:
    jmp         end

bad_end:
    move.l      0xCCCCCCCC, (A6)

end:
    halt

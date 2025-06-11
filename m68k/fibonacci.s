.data

input_addr:      .word  0x80
output_addr:     .word  0x84
overflow:        .word  0xCCCCCCCC

    .text
    .org         0x100

_start:
    movea.l      input_addr, A6
    movea.l      (A6), A6
    movea.l      output_addr, A4
    movea.l      (A4), A4
    move.b       0, D2
    move.l       (A6), D0

fibonacci_start:
    beq          fibonacci_end
    bmi          neg_end
    move.b       1, D2
    sub.l        1, D0
    beq          fibonacci_end
    move.b       0, D1

fibonacci_while:
   move.l        D2, D3
   add.l         D1, D2
   bvs           overflow_end
   move.l        D3, D1
   sub.l         1, D0
   beq           fibonacci_end
   jmp           fibonacci_while

overflow_end:
   movea.l       overflow, A5
   move.l        (A5), D2

fibonacci_end:
    move.l       D2, (A4)
    halt

neg_end:
    move.b       -1, D2
    jmp          fibonacci_end
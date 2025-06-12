    .data
 
input_addr:      .word  0x80               ; Input address where the number 'n' is stored
output_addr:     .word  0x84               ; Output address where the result should be stored
 
    .text
 
_start:
    movea.l  input_addr, A6
    movea.l  (A6), A6
    movea.l  output_addr, A7
    movea.l  (A7), A7
 
    move.l   (A6), D0
    move.l   D0, D1
 
sum_while:
    sub.l    1, D1
    beq      sum_end
    add.l    D1, D0
    jmp      sum_while
 
sum_end:
    move.l   D0, (A7)
 
    halt

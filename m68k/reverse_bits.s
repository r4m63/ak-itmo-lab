    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
mask:            .word  1

    .text
_start:
    movea.l  input_addr, A0
    movea.l  (A0), A0
    move.l   (A0), D0
    movea.l  mask, A1
    move.l   (A1), D1
    move.l   0, D2
    move.l   32, D4
    move.l   D1, D3
    and.l    D0, D3
    move.l   D3, D5

loop:
    lsl.l    1, D2
    move.l   D1, D3
    and.l    D0, D3
    or.l     D3, D2
    lsr.l    1, D0
    sub.l    1, D4
    bne      loop

output:
    movea.l  output_addr, A1
    movea.l  (A1), A1
    move.l   D2, (A1)

    halt

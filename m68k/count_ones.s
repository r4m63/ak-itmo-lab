    .data
input_addr:             .word  0x80

    .text
    .org     0x100

_start:

    movea.l  input_addr,  A0
    movea.l  (A0), A0
    move.l   (A0), D1
    move.l   D1, D0
    lsr.l    1,  D0
    and.l    0x55555555, D0
    sub.l    D0, D1
    move.l   D1, D0
    and.l    0x33333333, D0
    lsr.l    2,  D1
    and.l    0x33333333, D1
    add.l    D1, D0
    move.l   D0, D1
    lsr.l    4,  D1
    add.l    D1, D0
    and.l    0x0F0F0F0F, D0
    move.l   D0, D1
    lsl.l    8,  D1
    add.l    D1, D0
    move.l   D0, D1
    lsl.l    16, D1
    add.l    D1, D0
    lsr.l    24, D0
    move.b   D0, 4(A0)

    halt

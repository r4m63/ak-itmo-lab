    .data
input_addr:      .word  0x80
output_addr:     .word  0x84

    .text
    .org     0x88

_start:
    movea.l  1000, A7                        ; Init stack pointer
    movea.l  input_addr, A0
    movea.l  (A0), A0
    move.l   (A0), D0

    movea.l  output_addr, A1
    movea.l  (A1), A1

    move.l   24, D3                          ; Shift buffer (D1)

    move.l   0, D2                           ; Init result

    jsr      process_byte
    jsr      process_byte
    jsr      process_byte
    jsr      process_byte

    move.l   D2, (A1)
    halt


process_byte:
    link     A6, -4
    move.l   D0, -4(A6)
    xor.l    D1, D1
    move.b   -4(A6), D1
    and.l    0xFF, D1                        ; Clear high 3 bytes in buffer
    lsl.l    D3, D1
    or.l     D1, D2
    lsr.l    8, -4(A6)
    sub.l    8, D3
    move.l   -4(A6), D0
    unlk     A6
    rts
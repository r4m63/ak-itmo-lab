    .data
buffer:          .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84

    .text
_start:
    .org     0x88
    movea.l  input_addr, A0
    movea.l  (A0), A0
    movea.l  buffer, A6
    move.l   0, D2
    movea.l  output_addr, A7
    movea.l  (A7), A7

loop:
    move.l   (A0), D0
    move.l   D0, D1
    sub.l    0xA, D1
    beq      end
    move.l   D0, D1
    sub.l    'a' , D1
    ble      next
    move.l   D0, D1
    sub.l    'z' , D1
    bgt      next
    sub.b    0x20, D0

next:
    move.b   D0, (A6)+
    add.l    1, D2
    move.l   D2, D1
    sub.l    0x20, D1
    beq      over
    jmp      loop

end:
    move.b   0, (A6)+
    move.l   buffer, D0

out:
    move.b   (A1)+, D1
    sub.l    0x0, D1
    beq      stop
    move.b   D1, (A7)
    add.l    -1, D2
    bne      out

stop:
    halt

over:
    movea.l  buffer, A6
    move.l   0x20, D2

clear_buffer:
    move.b   0xcc, (A6)+
    add.l    -1, D2
    bne      clear_buffer
    move.l   0xcccccccc, D0
    move.l   D0, (A7)
    halt

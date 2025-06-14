.data
Buf:             .byte  '________________________________'
BufSize:         .word  0x20
InStopChar:      .word  '\n'
AsciiOffset:     .word  0x20
AsciiLowStart:   .word  0x60
AsciiLowEnd:     .word  0x7a
AsciiUpStart:    .word  0x40
AsciiUpEnd:      .word  0x5a
Separator:       .word  ' '
OvErr:           .word  0xcccccccc
Mask:            .word  0x7f
InputAddr:       .word  0x80
OutputAddr:      .word  0x84

.text
.org 0x90
_start:
    lui     sp,1
    addi    sp,sp,-4

    lui     t0,%hi(OutputAddr)
    addi    t0,t0,%lo(OutputAddr)
    lw      s0,0(t0)

    lui     t0,%hi(InputAddr)
    addi    t0,t0,%lo(InputAddr)
    lw      a0,0(t0)

    lui     t1,%hi(AsciiOffset)
    addi    t1,t1,%lo(AsciiOffset)
    lw      s1,0(t1)

    lui     t1,%hi(AsciiLowStart)
    addi    t1,t1,%lo(AsciiLowStart)
    lw      s2,0(t1)

    lui     t1,%hi(AsciiLowEnd)
    addi    t1,t1,%lo(AsciiLowEnd)
    lw      s3,0(t1)

    lui     t1,%hi(AsciiUpStart)
    addi    t1,t1,%lo(AsciiUpStart)
    lw      s4,0(t1)

    lui     t1,%hi(AsciiUpEnd)
    addi    t1,t1,%lo(AsciiUpEnd)
    lw      s5,0(t1)

    lui     t1,%hi(InStopChar)
    addi    t1,t1,%lo(InStopChar)
    lw      s6,0(t1)

    lui     t1,%hi(Separator)
    addi    t1,t1,%lo(Separator)
    lw      s7,0(t1)

    lui     t1,%hi(Mask)
    addi    t1,t1,%lo(Mask)
    lw      s8,0(t1)

    lui     t1,%hi(Buf)
    addi    a1,t1,%lo(Buf)

    lui     t1,%hi(BufSize)
    addi    t1,t1,%lo(BufSize)
    lw      a2,0(t1)

    mv 	    a3, a1
    addi    a1,a1,1

    addi    a4,zero,1

    jal     ra,capitalize_rec_pstr

    lui     t2,%hi(Buf)
    addi    t2,t2,%lo(Buf)
    addi    a5,a5,1

print_loop:
    addi    t2,t2,1
    addi    a5,a5,-1
    lw      t3,0(t2)
    and     t3,t3,s8
    beq     a5,zero,finish
    sw      t3,0(s0)
    j       print_loop
finish:
    halt


capitalize_rec_pstr:
    addi    sp,sp,-16
    sw      ra,12(sp)
    sw      a1,8(sp)
    sw      a4,4(sp)

    beq     a2,zero,overflow

    lw      t0,0(a0)
    and     t0,t0,s8
    beq     t0,s6,cap_end
    beq     t0,s7,cap_space

    beq     a4,zero,not_start
    ble     t0,s2,start_clear
    bgt     t0,s3,start_clear
    sub     t0,t0,s1

start_clear:
    addi    a4,zero,0
    j       write_char

not_start:
    ble     t0,s4,write_char
    bgt     t0,s5,write_char
    add     t0,t0,s1

write_char:
    sb      t0,0(a1)
    addi    a1,a1,1
    addi    a2,a2,-1
    jal     ra,capitalize_rec_pstr
    lw      ra,12(sp)
    lw      a1,8(sp)
    lw      a4,4(sp)
    addi    sp,sp,16
    jr      ra

cap_space:
    sb      t0,0(a1)
    addi    a1,a1,1
    addi    a2,a2,-1
    addi    a4,zero,1
    jal     ra,capitalize_rec_pstr
    lw      ra,12(sp)
    lw      a1,8(sp)
    lw      a4,4(sp)
    addi    sp,sp,16
    jr      ra

cap_end:
    sub     a5,a1,a3
    and     a5,a5,s8
    addi    a5,a5,-1
    sb      a5,0(a3)
    lw      ra,12(sp)
    lw      a1,8(sp)
    lw      a4,4(sp)
    addi    sp,sp,16
    jr      ra


overflow:
    lui     t1,%hi(OvErr)
    addi    t1,t1,%lo(OvErr)
    lw      t2,0(t1)
    sw      t2,0(s0)
    halt

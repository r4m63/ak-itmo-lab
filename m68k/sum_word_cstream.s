.text
.org 0x100
_start:
        movea.l     0x80, A0
        movea.l     0x84, A1
        move.l      0,    D1
        move.l      0,    D2

READ_LOOP:
        move.l (A0), D0
        beq     WRITE

        cmp.l   0x0, D0
        bmi     MINUS
CARRY:
        add.l   D0, D1
        bcc     READ_LOOP
        add.l   0x01, D2
        jmp     READ_LOOP

MINUS:
        add.l   0xFFFFFFFF, D2
        jmp     CARRY

WRITE:
        move.l  D2, (A1)
        move.l  D1, (A1)
        halt

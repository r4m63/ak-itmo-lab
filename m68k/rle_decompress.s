    .data

    ; D0 - for return codes


    ; D7 - for current buffer size counter
    ; A1 - inpu port
    ; A2 - output port
    ; A3 - For buffer address
    ; A4 - backup for buffer address

.org             0x90
    .text
_start:
    movea.l  0x70, A7                        ; stack
    movea.l  0x80, A1                        ; input port
    movea.l  0x84, A2                        ; uotput port
    move.l   0, D7                           ; Counter for buffer size
    movea.l  0, A3                           ; Buffer Pointer for writing
    movea.l  0, A4                           ; Buffer Pointer for reading
loop:
    move.b   (A1), D0                        ; Read the amount of symbols
    cmp.l    0xA,D0                          ; Check if its \n
    beq      end                             ; If it is, then we need to print the buffer
    sub.l    0x30, D0                        ; Turn '0' into 0, '1' -> 1, etc.
    move.l   D0, D1                          ; I don't remember why I decided to take copy
    ; Maybe because D0 was initialy return code register
    beq      read_remaining                  ; If the number is 0, then its an error,
    ; we read the remaining symbols and throw and error
    move.b   (A1), D2                        ; load symbol
    cmp.l    0xA,D2                          ; If its \n than its an error
    beq      error_exit
    add.l    D0, D7                          ; Add the amount of symbols to keep track of overflow
    cmp.l    0x40, D7                        ; If buffer is filled more than 0x40 bytes, than its overflow
    beq      overflow_instant                ; Just quit without reading \n ( test 14.yaml)
    bge      overflow_error_exit             ; Quit with reading last symbol \n (test 12.yaml)
repeat_char:
    move.l   D1, D1                          ; Set the Zero flag
    beq      loop                            ; If the counter is 0, than we're finished with this symbol.
    sub.l    1,D1                            ; Decrement the counter
    move.b   D2, (A3)+                       ; Save char to buffer
    jmp      repeat_char
end:
    move.b   0,(A3)                          ; Save \0 to buffer
read_loop:
    move.b   (A4)+, D0                       ; Read the char from buffer
    beq      hlt                             ; If \0 than halt
    move.b   D0, (A2)                        ; Print to output
    jmp      read_loop
hlt:
    halt
read_remaining:
 ; Read remaining symbols from input
    move.b   (A1), D0
    cmp.b    0xA,D0
    bne      read_remaining
error_exit:
    move.l   -1, (A2)
    halt
overflow_error_exit:
    move.l   -858993460, D0
    move.l   D0, (A2)
overflow_read_remaining:
    move.b   (A1), D0
    cmp.b    0xA,D0
    bne      overflow_read_remaining
    halt
overflow_instant:
    move.l   -858993460, D0
    move.l   D0, (A2)
    halt
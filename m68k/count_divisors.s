    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
 
_start:
    movea.l  input_addr, A6
    movea.l  (A6), A6
    ;movea.l  output_addr, A7
    ;movea.l  (A7), A7
 
    move.l   (A6)+, D0                       ; D0 <- input value
    move.b   0, D1                           ; D1 <- counter
    move.b   1, D2                           ; D2 <- potential divisor
 
    move.l   D0, D3
    bmi      error
    beq      error
 
count_divisors:
    move.l   D0, D3                          ; D3 = D0
    div.l    D2, D3
    mul.l    D2, D3
    sub.l    D0, D3                          ; if (D0 \ D2) * D2 = D0: D2 - real divisor
 
    beq      add_divisor
 
    jmp      loop_increment
 
add_divisor:
    add.b    1, D1
    jmp      loop_increment
 
loop_increment:
    add.b    1, D2                           ; D2 += 1
    move.l   D2, D4                          ; D4 = D2
    sub.l    D0, D4
    sub.b    1, D4
    beq      finish
 
    jmp      count_divisors
 
finish:
    move.l   D1, (A6)
    halt
 
error:
    move.l   -1, (A6)
    halt

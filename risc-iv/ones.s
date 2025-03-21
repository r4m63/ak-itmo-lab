    .data
input_address:   .word  0x80
output_address:  .word  0x84

    .text

_start:
    lui      t0, %hi(input_address)          ; t0 = 0
    addi     t0, t0, %lo(input_address)      ; t0 <- 80

    lw       t0, 0(t0)                       ; t0 = *input_address
    lw       t0, 0(t0)                       ; t0 = *t0

    addi     t1, zero, 1                     ; using t1 as mask
    addi     t4, zero, 1                     ; using t4 as one, cuz heres no immediate loads
loop:
    beqz     t1, end                         ; if mask is zero, means we checked all bits
    and      t2, t0, t1                      ; doing and between mask and our value
    sll      t1, t1, t4                      ; shifting mask
    beqz     t2, loop                        ; if t2 is zero, means bcurrent bit is 0
    add      t3, t3, t4                      ; otherwise incrementing anwser
    j        loop                            ; jumping to the loop begining
end:
    lui      t0, %hi(output_address)         ; t0 = 0
    addi     t0, t0, %lo(output_address)     ; t0 <- 84
    lw       t0, 0(t0)                       ; t0 = *output_address
    sw       t3, 0(t0)                       ; *t0 = t3 (answer)
    halt

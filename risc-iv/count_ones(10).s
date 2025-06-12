    .data
input_address:   .word  0x80
output_address:  .word  0x84
 
    .text
 
_start:
    lui      t0, %hi(input_address)
    addi     t0, t0, %lo(input_address)
 
    lw       t0, 0(t0)
    lw       t0, 0(t0)
 
    addi     t1, zero, 1
    addi     t4, zero, 1
loop:
    beqz     t1, end
    and      t2, t0, t1
    sll      t1, t1, t4
    beqz     t2, loop
    add      t3, t3, t4
    j        loop
end:
    lui      t0, %hi(output_address)
    addi     t0, t0, %lo(output_address)
    lw       t0, 0(t0)
    sw       t3, 0(t0)
    halt

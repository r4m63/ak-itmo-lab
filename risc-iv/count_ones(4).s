    .data
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
_start:
    addi     sp, sp, 0x500
 
    jal      ra, main_logic
main_logic:
    addi     ra, ra, 16                      ;в ra адрес на команду через 3
    addi     sp, sp, -4
    sw       ra, 0(sp)
    j        handle_input
while:
    ;t1 - число, t2 - результат битового И, a0 = 1, a1 - счетчик
    and      t2, t1, a0                      ;t2 <- t1 & 1
    beqz     t1, end
    add      a1, a1, t2
    srl      t1, t1, a0
    j        while
end:
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
 
    lw       t0, 0(t0)
 
    sw       a1, 0(t0)
    halt
handle_input:
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
 
    lw       t0, 0(t0)
    lw       t1, 0(t0)
    addi     a0, zero, 1                     ;a0 <- 0 + 1
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra

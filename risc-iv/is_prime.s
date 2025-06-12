    .data

input_addr:   .word 0x80
output_addr:  .word 0x84

    .text

.org 0x88

error_input_out_of_bounds:
    addi      a0, zero, -1
    jal       ra, f_print_res
    halt

f_init_stack:
    addi      sp, zero, 0x500
    jr        ra

f_is_prime:
    ble       a0, zero, error_input_out_of_bounds
    addi      t1, zero, 2
    bgt       t1, a0, is_prime_false
    beq       t1, a0, is_prime_true

is_prime_loop:
    rem       t2, a0, t1
    beqz      t2, is_prime_false
    mul       t2, t1, t1
    bleu      a0, t2, is_prime_true
    addi      t1, t1, 1
    j         is_prime_loop

is_prime_true:
    addi      a0, zero, 1
    jr        ra

is_prime_false:
    xor       a0, a0, a0
    jr        ra

f_print_res:
    lui       t0, %hi(output_addr)
    addi      t0, t0, %lo(output_addr)
    lw        t0, 0(t0)
    sw        a0, 0(t0)
    jr        ra

f_do_task:
    addi      sp, sp, -4
    sw        ra, 0(sp)
    lui       t0, %hi(input_addr)
    addi      t0, t0, %lo(input_addr)
    lw        t0, 0(t0)
    lw        a0, 0(t0)
    jal       ra, f_is_prime
    jal       ra, f_print_res
    lw        ra, 0(sp)
    addi      sp, sp, 4
    jr        ra

_start:
    jal       ra, f_init_stack
    jal       ra, f_do_task
    halt

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
  ; args: a0 - number to be checked whether it is prime
  ; returns: a0 - 1 or 0 depending on whether the input number is prime
  ble       a0, zero, error_input_out_of_bounds ; n < 1 => error
  addi      t1, zero, 2                         ; t1 = 2
  bgt       t1, a0, is_prime_false              ; n < 2 (n == 1) => not prime
  beq       t1, a0, is_prime_true               ; n == 2 ? => prime
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
  addi      sp, sp, -4                      ; reserve word in stack for return address
  sw        ra, 0(sp)                       ; save ra to stack
 
  lui       t0, %hi(input_addr)             ; higher byte to higher byte
  addi      t0, t0, %lo(input_addr)         ; lower byte to lower byte
  lw        t0, 0(t0)                       ; load the input_addr itself
 
  lw        a0, 0(t0)                       ; load value from input
 
  jal       ra, f_is_prime
  jal       ra, f_print_res
 
  lw        ra, 0(sp)                       ; get ra from stack
  addi      sp, sp, 4                       ; move stack pointer back
  jr        ra
 
_start:
  jal       ra, f_init_stack
  jal       ra, f_do_task
  halt

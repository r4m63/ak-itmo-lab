  .data
input_addr:   .word 0x80
output_addr:  .word 0x84
 
.text
.org 0x88
 
error_bounds:
  addi      a0, zero, -1
  jal       ra, print_res
  halt
 
init_stack:
  addi      sp, zero, 0x500
  jr        ra
 
is_prime:
  ble       a0, zero, error_bounds ; if n < 1 => error
  addi      t1, zero, 2                         
  bgt       t1, a0, is_prime_false ; if n < 2 (n == 1) -> not prime
  beq       t1, a0, is_prime_true  ; if n == 2 -> prime
 
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
 
 
print_res:
  lui       t0, %hi(output_addr)
  addi      t0, t0, %lo(output_addr)
  lw        t0, 0(t0)
  sw        a0, 0(t0)
  jr        ra
 
do_task:
  addi      sp, sp, -4                      
  sw        ra, 0(sp)                       
 
  lui       t0, %hi(input_addr)             
  addi      t0, t0, %lo(input_addr)         
  lw        t0, 0(t0)                       
 
  lw        a0, 0(t0)                       
 
  jal       ra, is_prime
  jal       ra, print_res
 
  lw        ra, 0(sp)                       
  addi      sp, sp, 4                       
  jr        ra
 
_start:
  jal       ra, init_stack
  jal       ra, do_task
  halt

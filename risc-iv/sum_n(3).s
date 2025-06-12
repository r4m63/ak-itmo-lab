  .data
input_addr:   .word 0x80
output_addr:  .word 0x84
overflow_val: .word 0xCCCC_CCCC
  .text
 
.org 0x88
 
f_incorrect_input:
  addi   a0, zero, -1
  jal    ra, f_print_n
  halt
 
f_overflow_error:
  lui   a0, %hi(overflow_val)
  addi  a0, a0, %lo(overflow_val)
  lw    a0, 0(a0)
  jal   ra, f_print_n
  halt
 
f_stack_init:
  addi  sp, zero, 0x500
  jr    ra
 
ret:
  lw    ra, 0(sp)
  addi  sp, sp, 4
  jr    ra
 
f_print_n:          ; a0 - word to print
  addi  sp, sp, -4
  sw    ra, 0(sp)
  lui   t0, %hi(output_addr)
  addi  t0, t0, %lo(output_addr)
  lw    t0, 0(t0)
  sw    a0, 0(t0)
  j     ret
 
f_sum_n_and_print:  ; a0 - n
  addi  sp, sp, -4
  sw    ra, 0(sp)
 
  addi  t0, a0, 1
  addi  t2, zero, 2 ; divisor
  rem   t1, t0, t2  ; t1 = (n + 1) % 2
  beqz  t1, div_t0
div_a0:
  div   a0, a0, t2
  j     continue
div_t0:
  div   t0, t0, t2
continue:
  mulh  t1, a0, t0
  bnez  t1, f_overflow_error
  mul   a0, a0, t0
  ble   a0, zero, f_overflow_error
  jal   ra, f_print_n
  j     ret
 
_start:
  jal   ra, f_stack_init
  lui   t0, %hi(input_addr)
  addi  t0, t0, %lo(input_addr)
  lw    t0, 0(t0)
  lw    a0, 0(t0)
  ble   a0, zero, f_incorrect_input
  jal   ra, f_sum_n_and_print
  halt

  .data
input_addr:       .word 0x80
output_addr:      .word 0x84
n:                .word 0x00
current_divisor:  .word 0x02
wrong_inp_val:    .word -1
 
  .text
.org 0x88
wrong_inp_err:
  load          wrong_inp_val
  jmp           print_acc
  halt
 
_start:
  load_ind      input_addr      ; acc = n
  store         n               ; n = n
  beqz          wrong_inp_err   ; n == 0
  ble           wrong_inp_err   ; n < 0
  sub           current_divisor
  beqz          is_prime
  add           current_divisor
  rem           current_divisor
  beqz          not_prime
  load_imm      1
  sub           n
  beqz          not_prime
  add           n
  add           current_divisor
  store         current_divisor
loop:
  load          current_divisor
  mul           current_divisor ; acc = current_divisor^2
  bvs           is_prime
  sub           n               ; acc = current_divisor^2 - n
  beqz          is_prime
  bgt           is_prime        ; current_divisor^2 >= n -> is prime
  load          n
  rem           current_divisor ; n % current_divisor
  beqz          not_prime       ; zero ? -> not prime
  load_imm      2
  add           current_divisor ; current_divisor++
  store         current_divisor
  jmp           loop
is_prime:
  load_imm      1
  jmp           print_acc
not_prime:
  load_imm      0
print_acc:
  store_ind     output_addr
  halt

  .data
input_addr:     .word 0x80
output_addr:    .word 0x84
 
  .text
 
f_read_word:
  lui t0, %hi(input_addr)
  addi t0, t0, %lo(input_addr)
  lw t0, 0(t0)
  lw a0, 0(t0)
  jr ra
 
f_print_word:
  lui t0, %hi(output_addr)
  addi t0, t0, %lo(output_addr)
  lw t0, 0(t0)
  sw a0, 0(t0)
  jr ra
 
  .data
.org 0x90
 
  .text
f_reverse_word:
  addi sp, sp, -4
  sw ra, 0(sp)
  beqz a1, reverse_word_end
  addi a1, a1, -1
  addi t0, zero, 1
  and t1, t0, a0
  sll a2, a2, t0
  add a2, a2, t1
  srl a0, a0, t0
  jal ra, f_reverse_word
reverse_word_end:
  lw ra, 0(sp)
  addi sp, sp, 4
  jr ra
 
f_compare_words:
  beq a0, a1, compare_words_true
  xor a0, a0, a0
  jr ra
compare_words_true:
  addi a0, zero, 1
  jr ra
 
_start:
  addi sp, zero, 0x500
  jal ra, f_read_word
  mv s0, a0             ; save word to compare
  addi a1, zero, 32
  add a2, zero, zero
  jal ra, f_reverse_word
  mv a0, a2
  mv a1, s0
  jal ra, f_compare_words
  jal ra, f_print_word
  halt

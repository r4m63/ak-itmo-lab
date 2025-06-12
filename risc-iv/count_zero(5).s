 .data
input_addr:     .word 0x80
output_addr:    .word 0x84
unsigned_mask:  .word 0x7FFF_FFFF
  .text
 
.org 0x88
f_count_zeros:      ; a0 - number, a1 - counter, t0 - temp for current 0 or 1, t2 - hardcoded 1 for shifts, t3 - mask
  addi      sp, sp, -4
  sw        ra, 0(sp)
  addi      t2, zero, 1
  beqz      a0, count_zeros_end
  bgt       a0, zero, count_zeros_positive
  addi      a1, a1, -1
  lui       t3, %hi(unsigned_mask)
  addi      t3, t3, %lo(unsigned_mask)
  lw        t3, 0(t3)
  and       a0, a0, t3
count_zeros_positive:
  and       t0, t2, a0
  sub       a1, a1, t0
  sra       a0, a0, t2
  mv        t3, zero
  jal       ra, f_count_zeros
count_zeros_end:
  lw        ra, 0(sp)
  addi      sp, sp, 4
  jr        ra
 
 
print_res:
  lui       t0, %hi(output_addr)
  addi      t0, t0, %lo(output_addr)
  lw        t0, 0(t0)
  sw        a0, 0(t0)
  jr        ra
 
 
_start:
  addi      sp, zero, 0x500
  lui       t0, %hi(input_addr)
  addi      t0, t0, %lo(input_addr)
  lw        t0, 0(t0)
 
  lw        a0, 0(t0)                       ; load value from input
  addi      a1, zero, 0x20                  ; zeros counter
 
  jal       ra, f_count_zeros
  mv        a0, a1
  jal       ra, print_res
  halt

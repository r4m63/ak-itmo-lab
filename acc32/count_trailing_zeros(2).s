  .data
 
input_addr:     .word 0x80
output_addr:    .word 0x84
n:              .word 0x0
counter:        .word 0x0
ONE_CONST:      .word 1
 
  .text
 
zero:
  load_imm      32
  store_ind     output_addr
  halt
 
 
_start:
  load_ind      input_addr
  store         n
  beqz          zero
count_loop:
  load          n
  and           ONE_CONST
  bnez          count_end
  load_imm      1
  add           counter
  store         counter
  load          n
  shiftr        ONE_CONST
  store         n
  jmp           count_loop
count_end:
  load          counter
  store_ind     output_addr
  halt

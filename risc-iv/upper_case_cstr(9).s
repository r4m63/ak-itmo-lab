  .data
 
buffer:       .byte '________________________________'
offset:       .byte '___'
null_term:    .byte 0, '___'
input_addr:   .word 0x80
output_addr:  .word 0x84
error_code:   .word 0xCCCC_CCCC
 
  .text
.org 0x100
 
ret_addr:
  lw        a0, 0(sp)
  addi      sp, sp, 4
  jr        a0
 
error_handler:
  lui       t0, %hi(output_addr)
  addi      t0, t0, %lo(output_addr)
  lw        t0, 0(t0)
 
  lui       t1, %hi(error_code)
  addi      t1, t1, %lo(error_code)
  lw        t1, 0(t1)
 
  sw        t1, 0(t0)
  halt
 
read_to_buffer:
  addi      sp, sp, -4
  sw        a0, 0(sp)
 
  lui       t2, %hi(buffer)
  addi      t2, t2, %lo(buffer)
 
read_loop:
  addi      t3, zero, 0x20
  ble       t3, t2, error_handler
  lw        t1, 0(t0)
  addi      t3, zero, 10
  beq       t3, t1, end_read
  addi      t3, zero, 'z'
  bgt       t1, t3, continue_read
  addi      t3, zero, 'a'
  bgt       t3, t1, continue_read
  sub       t1, t1, t3
  addi      t1, t1, 'A'
 
continue_read:
  sb        t1, 0(t2)
  addi      t2, t2, 1
  j         read_loop
 
end_read:
  lui       t1, %hi(null_term)
  addi      t1, t1, %lo(null_term)
  lw        t1, 0(t1)
  sw        t1, 0(t2)
  j         ret_addr
 
print_buffer:   ; t0=output ptr, a0=ret addr
  addi      sp, sp, -4
  sw        a0, 0(sp)
 
  addi      t3, zero, 0xFF
 
  lui       t2, %hi(buffer)
  addi      t2, t2, %lo(buffer)
 
print_loop:
  lw        t1, 0(t2)
  and       t1, t1, t3
  beqz      t1, end_print
  sb        t1, 0(t0)
  addi      t2, t2, 1
  j         print_loop
 
end_print:
  j         ret_addr
 
_start:
  lui       sp, 0x0
  addi      sp, sp, 0x200
 
  lui       t0, %hi(input_addr)
  addi      t0, t0, %lo(input_addr)
  lw        t0, 0(t0)
 
  jal       a0, read_to_buffer
 
  lui       t0, %hi(output_addr)
  addi      t0, t0, %lo(output_addr)
  lw        t0, 0(t0)
 
  jal       a0, print_buffer
  halt

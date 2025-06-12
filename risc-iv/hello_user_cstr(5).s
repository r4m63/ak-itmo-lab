.data
buffer:         .byte 'Hello, '
input_buffer:   .byte '_________________________'
question:       .byte 'What is your name?\n', 0
input_addr:     .word 0x80
output_addr:    .word 0x84
overflow:       .word 0xCCCC_CCCC
 
.text
.org 0x88
f_print:
  lui 	t0, %hi(output_addr)
  addi 	t0, t0, %lo(output_addr)
  lw 	t0, 0(t0)
  addi 	t1, zero, 0xff
print_loop:
  lw 	t2, 0(a0)
  and 	t2, t2, t1
  beqz 	t2, print_end
  sw 	t2, 0(t0)
  addi 	a0, a0, 1
  j 	print_loop
print_end:
  jr 	ra
 
f_ask_name:
  addi 	sp, sp, -4
  sw 	ra, 0(sp)
  lui 	a0, %hi(question)
  addi 	a0, a0, %lo(question)
  jal 	ra, f_print
  lw 	ra, 0(sp)
  addi 	sp, sp, 4
  jr 	ra
 
f_read_name:
  lui 	t0, %hi(input_addr)
  addi 	t0, t0, %lo(input_addr)
  lw 	t0, 0(t0)
  lui 	t1, %hi(input_buffer)
  addi 	t1, t1, %lo(input_buffer)
  addi 	t2, zero, 30			 ; pointer limit
  addi 	t4, zero, 10
read_name_loop:
  lw 	t3, 0(t0)
  bnez 	t3, continue
  addi	t5, zero, '!'
  sb	t5, 0(t1)
  addi	t1, t1, 1
  beq   t1, t2, read_name_err
continue:  
  beq 	t3, t4, read_name_end
  sb 	t3, 0(t1)
  addi 	t1, t1, 1
  beq   t1, t2, read_name_err
  j 	read_name_loop
read_name_err:
  j 	f_overflow
read_name_end:
  addi 	t0, zero, '!'
  sb 	t0, 0(t1)
  addi 	t1, t1, 1
  sb 	zero, 0(t1)
  jr 	ra
 
f_stack_init:
  addi 	sp, zero, 0x500
  jr 	ra
 
f_overflow:
  lui 	t0, %hi(overflow)
  addi 	t0, t0, %lo(overflow)
  lw 	t0, 0(t0)
  lui 	t1, %hi(output_addr)
  addi 	t1, t1, %lo(output_addr)
  lw 	t1, 0(t1)
  sw 	t0, 0(t1)
  halt
 
_start:
  jal 	ra, f_stack_init
  jal 	ra, f_ask_name
  jal 	ra, f_read_name
  lui 	a0, %hi(buffer)
  addi 	a0, a0, %lo(buffer)
  jal 	ra, f_print
  halt

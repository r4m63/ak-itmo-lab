  .data
input_addr:     .word 0x80
output_addr:    .word 0x84
 
  .text
.org 0x88
switch_endian:
  lit 4 >r
get_bytes_loop:
  dup lit 0x00ff and      \; get last byte
  r> over >r >r
  2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/ \; rshift one byte
  next get_bytes_loop
  r> r> r> r> r>
  lit 2 >r
add_bytes_loop:
  2* 2* 2* 2* 2* 2* 2* 2* \; lshift 1 byte
  +
  next add_bytes_loop
  ;
 
print_top:
  @p output_addr a! !
  ;
 
_start:
  @p input_addr a! @
  switch_endian
  print_top
  halt

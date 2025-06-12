    .data
 
input_addr:      .word 0x80
output_addr:     .word 0x84
mask:            .word 0x00FF
 
    .text
 
.org 0x88
 
to_little_endian:
  lit 4                     \ stack: N, i = 4
loop:
  dup                       \ stack: N, i, i
  if end_loop               \ if (i == 0) goto end_loop
  over                      \ stack: i, N
  dup                       \ stack: i, N, N
  @p mask                   \ stack: i, N, N, 0xFF
  and                       \ stack: i, N, N & 0xFF
  >r                        \ save byte to rstack
  2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/   \ shift N right by 8
  over                      \ stack: N, i
  lit -1 +                  \ stack: N, i - 1
  loop ;
end_loop:
  drop drop                 \ clear N, i
  r> r> r> r>               \ now: byte1 byte2 byte3 byte4 (в порядке little-endian)
  lit 3 a!                  \ i = 3
sum_loop:
  a if end_sum_loop
  2* 2* 2* 2* 2* 2* 2* 2*   \ << 8
  +                         \ (acc << 8) + next_byte
  a lit -1 + a!
  sum_loop ;
end_sum_loop:
  ;
 
 
_start:
    @p input_addr a! @      \ read number
 
    to_little_endian
 
    @p output_addr a! !     \ print number
    halt

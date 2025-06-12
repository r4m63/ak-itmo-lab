    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
mask:            .word  0x00FF
 
    .text
 
.org 0x88
 
to_big_endian:
  lit 4                     \ stack: N, i = 4
loop:
  dup                       \ stack: N, i, i
  if end_loop               \ if (i == 0) goto end_loop
  over                      \ stack: i, N
  dup                       \ stack: i, N, N
  @p mask                   \ stack: i, N, N, 0xF
  and                       \ stack: i, N, N&0xF
  >r                        \ stack: i, N              rstack: N&0xF
  2/ 2/ 2/ 2/ 2/ 2/ 2/ 2/   \ stack: i, N >> 8
  over                      \ stack: N, i
  lit -1 +                  \ stack: N, i - 1
  loop ;
end_loop:                   \ stack: N, i              rstack: N1, N2, N3, N4
  drop drop                 \ stack: -                 rstack: N1, N2, N3, N4
  r> r> r> r>               \ pick parts from rstack
  lit 3 a!                  \ i = 3
sum_loop:
  a if end_sum_loop         \ if i == 0 than end
  2* 2* 2* 2* 2* 2* 2* 2*   \ stack: N << 8
  +                         \ stack: (N << 8) + N_i
  a lit -1 + a!             \ i--
  sum_loop ;
end_sum_loop:
  ;
 
 
 
_start:
    @p input_addr a! @      \ read number
 
    to_big_endian
 
    @p output_addr a! !     \ print number
    halt

  .data
input_addr:     .word 0x80
output_addr:    .word 0x84
 
sign_mask:      .word 0x8000_0000
 
lower_word:     .word 0x00
upper_word:     .word 0x00
 
  .text
 
.org 0x85
 
print_words:
  @p lower_word
  @p upper_word
  @p output_addr a! ! !
  ;
sum_words:
  @p input_addr a! @                    \ get number of words
  >r                                    \ push it to the rstack
  next loop
  end_sum ;
loop:
  @p input_addr a! @                    \ s: current_word
  dup @p sign_mask and                  \ s: current_word, current_sign
  if end_upper
dec_upper:
  lit -1 @p upper_word + !p upper_word  \ s: current_word
end_upper:
  lit 1 eam                             \ s: set eam
  @p lower_word +                       \ s: current_word + lower_word, !!CARRY SET!!
  dup dup +                             \ s: sum, 2sum + c
  lit 0 eam                             \ drop eam flag
  over dup dup !p lower_word +          \ s: 2sum + c, 2sum
  inv lit 1 + +                         \ s: c
  @p upper_word + !p upper_word         \ s:
  next loop
end_sum:
  ;
 
 
_start:
  sum_words
  print_words
  halt

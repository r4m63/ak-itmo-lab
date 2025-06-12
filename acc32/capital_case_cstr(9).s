  .data
buffer:          .byte '________________________________'
padding:         .byte '___'
null_terminator: .byte  0, '___'
input_addr:      .word  0x80
output_addr:     .word  0x84
i:               .word  0
newline:         .word  '\n'
one_const:       .word  1
mask:            .word  0xFF
a_lower:         .word  'a'
z_lower:         .word  'z'
a_upper:         .word  'A'
z_upper:         .word  'Z'
whitespace:      .word  ' '
word_started:    .word  0x0
temp:            .word  0
error_code:      .word  0xCCCC_CCCC
 
  .text
 
 
.org 0x88
_start:
read_string:
  load_imm      buffer          ; acc = buffer
  store         i               ; i = buffer
read_loop:
  load_imm      0x20
  sub           i
  beqz          error
  load_ind      input_addr      ; acc = *(input)
  and           mask            ; acc & 0xFF
  sub           newline         ; acc - '\n'
  beqz          read_end        ; acc == '\n' ? goto end
  add           newline         ; restore acc
 
  sub           a_lower         ; c -= 'a'
  ble           not_lower_a     ; c < 'a' ? => not_lower
  add           a_lower         ; restore c
  sub           z_lower         ; c -= 'z'
  bgt           not_lower_z     ; c >'z' => not_lower
  add           z_lower
 
  store         temp
  load          word_started
  beqz          upperize        ; word not started and char is lower => make char upper
no_upper:
  load          temp
  jmp           check_upper     ; NOTE: replaced from check_whitespace
upperize:
  load          temp
 
  sub           a_lower
  add           a_upper         ; c += 'A' (to uppercase)
  jmp           check_whitespace
not_lower_a:
  add           a_lower
  jmp           check_upper
not_lower_z:
  add           z_lower
check_upper:
  sub           a_upper         ; c -= 'A'
  ble           not_upper_a     ; c < 'A' ? => not_upper
  add           a_upper         ; restore c
  sub           z_upper         ; c -= 'Z'
  bgt           not_upper_z     ; c >'Z' => not_upper
  add           z_upper
 
  store         temp
  load          word_started
  beqz          no_lowerize        ; word started and char is upper => make char lower
  jmp           lowerize
no_lowerize:
  load          temp
  jmp           check_whitespace
lowerize:
  load          temp
 
  sub           a_upper
  add           a_lower         ; c += 'a' (to lowercase)
  jmp           check_whitespace
 
not_upper_a:
  add           a_upper
  jmp           check_whitespace
not_upper_z:
  add           z_upper
check_whitespace:
  sub           whitespace      ; acc = c - ' '
  beqz          is_whitespace
  jmp           not_whitespace
is_whitespace:
  load_imm      0               ; acc = 0
  store         word_started
  load          whitespace      ; acc = ' '
  jmp           continue
not_whitespace:
  add           whitespace      ; acc = c
  store         temp            ; acc = c; temp = c
  load_imm      1               ; acc = 1; temp = c
  store         word_started    ; acc = 1; temp = c
  load          temp            ; acc = c; temp = c
continue:
  store_ind     i               ; buffer[i] = acc
  load          i               ; acc = i
  add           one_const       ; i++
  store         i
  jmp           read_loop       ; next iteration
read_end:
  load          null_terminator
  store_ind     i
 
print_buffer:
  load_imm      buffer          ; acc = buffer
  store         i               ; i = buffer
print_loop:
  load_ind      i               ; acc = buffer[i]
  and           mask            ; c & 0xFF (cut to byte)
  beqz          end             ; c == '\0' ? end of string
  store_ind     output_addr     ; c -> stdout
  load          i               ; acc = i
  add           one_const       ; i++
  store         i               ; save i
  jmp           print_loop      ; next iteration
end:
  halt
 
error:
  load          error_code
  store_ind     output_addr
  halt

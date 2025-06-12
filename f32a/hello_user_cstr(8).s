  .data
ready_buffer:   .byte 'Hello, '
buffer:         .byte '________________________'
buffer_end:     .byte '___'
endline:        .word '\n'
ptr_limit: 		.word 30
question:       .byte 'What is your name?\n\0'
byte_mask:      .word 0x0000_00FF
input_addr:     .word 0x80
output_addr:    .word 0x84
 
  .text
 
.org 0x88
 
overflow_error:
  @p output_addr a!
  lit 0xCCCC_CCCC !
  halt
 
sub:
  inv lit 1 + +
  ;
 
read_name:
  lit buffer a!         \ a = &buffer
  @p input_addr b!      \ b = stdin
read_name_loop:
  a @p ptr_limit sub  \ ptr - ptr_limit
  -if overflow_error
  @b dup lit -1 +	  \ null terminator checking
  -if continue_read
  lit '!' !+
continue_read:
  dup @p endline xor \ cmp c with endline
  if read_name_end
  !+
  read_name_loop ;
read_name_end:
  drop
  a lit buffer xor if overflow_error
  lit '!' !+
  lit 0x5f5f5f00 !
  ;
 
 
print_from_a:
  @p output_addr b!
print_buffer_loop:
  @+ @p byte_mask and   \ push sym
  dup if print_buffer_end
  !b
  print_buffer_loop ;
print_buffer_end:
  drop
  ;
 
_start:
  lit question a!
  print_from_a
  read_name
  lit ready_buffer a!
  print_from_a
  halt

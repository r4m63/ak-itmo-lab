  .data
buffer:               .byte 0, 'Hello, _________________________', '___'
symbols_left:         .word 0x0
exclamation:          .byte '!___'
input_addr:           .word 0x80
output_addr:          .word 0x84
question_msg:         .byte 'What is your name?\n'
question_msg_length:  .word 18
overflow_msg:         .word 0xCCCC_CCCC
i:                    .word 0x0
temp:                 .word 0x0
one_const:            .word 0x1
byte_mask:            .word 0x00FF
buffer_ptr:           .word 0x8
newline:              .word 10
 
  .text
.org 0x88
 
_start:
 
ask_question:
  load      question_msg_length
  sub       i                     ; acc = len - i
  ble       read_name_to_buffer
  load_imm  question_msg
  add       i                     ; acc = &question_msg + i
  store     temp
  load_ind  temp                  ; acc = *(&question_msg + i) == question_msg[i]
  and       byte_mask
  store_ind output_addr
  load      i
  add       one_const
  store     i
  jmp       ask_question
 
read_name_to_buffer:
  load_imm  0x1E
  sub       buffer_ptr
  ble       overflow_err
  load_ind  input_addr
  store_ind buffer_ptr
  sub       newline
  beqz      end_input
  load      buffer_ptr
  add       one_const
  store     buffer_ptr
  jmp       read_name_to_buffer
end_input:
  load      exclamation
  store_ind buffer_ptr
  load      buffer
  add       buffer_ptr
  store     buffer
  load_imm  0x7
  sub       buffer_ptr
  beqz      overflow_err      ; if empty line
 
print_buffer:
  load      buffer
  and       byte_mask
  store     symbols_left
  load_imm  buffer
  add       one_const
  store     buffer_ptr
print_loop:
  load      symbols_left
  beqz      end
  sub       one_const
  store     symbols_left
  load_ind  buffer_ptr
  and       byte_mask
  store_ind output_addr
  load      buffer_ptr
  add       one_const
  store     buffer_ptr
  jmp       print_loop
 
end:
  halt
 
overflow_err:
  load      overflow_msg
  store_ind output_addr
  halt

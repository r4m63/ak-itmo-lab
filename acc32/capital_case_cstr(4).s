    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
ptr:             .word  0x0
buffer_addr:     .word  0x88
answer_addr:     .word  0x0
answer_size:     .word  0x20
newline_char:    .word  '\n'               ; ASCII code for newline
whitespace_char: .word  ' '                ; ASCII code for whitespace
a_char:          .word  'a'                ; ASCII code for 'a'
z_char:          .word  'z'                ; ASCII code for 'z'
A_char:          .word  'A'                ; ASCII code for 'A'
Z_char:          .word  'Z'                ; ASCII code for 'Z'
__char:          .word  '_'                ; ASCII code for '_'
whitespace_flag: .word  0x1
mask:            .word  0x000000FF
error_char:      .word  0xCCCCCCCC
const_0:         .word  0x0
const_1:         .word  0x1
const_4:         .word  0x4
const_32:        .word  0x20
 
 
    .org 0x90
    .text
 
_start:
 
    load_ind     input_addr                  ; acc <- mem[mem[input_addr]]
    store_ind    buffer_addr                 ; mem[mem[buffer_addr]] <- acc
 
check_newline:
 
    sub          newline_char                ; if acc == 10:
    beqz         end                         ; GOTO end
    add          newline_char
 
check_whitespace:
 
    sub          whitespace_char             ; if acc != ' ':
    bnez         check_lowercase             ; GOTO check_lowercase
 
    load_addr    const_1                     ; else:
    store_addr   whitespace_flag             ; whitespace_flag <- 1
    jmp          save_whitespace             ; GOTO save_whitespace
 
check_lowercase:
 
    load_ind     buffer_addr                 ; acc <- mem[mem[buffer_addr]]
 
    sub          a_char                      ; if acc < 'a':
    ble          check_uppercase             ; GOTO check_uppercase
 
    add          a_char
    sub          z_char                      ; elif acc > 'z':
    bgt          check_uppercase             ; GOTO check_uppercase
 
    load_addr    whitespace_flag             ; elif whitespace_flag == 0:
    beqz         check_uppercase             ; GOTO check_uppercase
 
    load_ind     buffer_addr                 ; acc <- mem[mem[buffer_addr]]
    sub          const_32                    ; acc -= 32
    store_ind    buffer_addr                 ; mem[mem[buffer_addr]] <- acc
    jmp          save
 
check_uppercase:
 
    load_ind     buffer_addr                 ; acc <- mem[mem[buffer_addr]]
 
    sub          A_char                      ; if acc < 'A':
    ble          save                        ; GOTO save
 
    add          A_char
    sub          Z_char                      ; elif acc > 'Z':
    bgt          save                        ; GOTO save
 
    load_addr    whitespace_flag             ; elif whitespace_flag != 0:
    bnez         save                        ; GOTO save
 
    load_ind     buffer_addr                 ; acc <- mem[mem[buffer_addr]]
    add          const_32                    ; acc += 32
    store_ind    buffer_addr                 ; mem[mem[buffer_addr]] <- acc
 
 
 
save:
 
    load_addr    const_0
    store_addr   whitespace_flag             ; whitespace_flag <- 0
 
save_whitespace:
 
    load_ind     buffer_addr                 ; acc <- mem[mem[buffer_addr]]
    store_ind    ptr                         ; mem[mem[ptr]] <- acc
 
    load_addr    ptr
    add          const_1
    store_addr   ptr                         ; ptr <- ptr + 1
 
    sub          answer_size
    beqz         error
 
    jmp          _start                      ; else: GOTO _start
 
end:
 
    load_addr    const_0
    store_ind    ptr                         ; mem[mem[ptr]] <- '0'
 
align_buffer:
 
    load_addr    ptr
    sub          answer_size
    beqz         print
 
    add          answer_size
    add          const_1
    store_addr   ptr
 
    load_addr    __char
    store_ind    ptr
    jmp          align_buffer
 
print:
 
    load_addr    answer_addr
    store_addr   ptr
 
print_loop:
 
    load_ind     ptr
    and          mask
    beqz         exit
    store_ind    output_addr                 ; mem[mem[output_addr]] <- mem[mem[ptr]]
 
    load_addr    ptr
    add          const_1
    store_addr   ptr
 
    jmp          print_loop
exit:
 
    halt
 
error:
 
    load_addr    error_char
    store_ind    output_addr                 ; mem[mem[output_addr]] <- '0xCC'
 
    halt

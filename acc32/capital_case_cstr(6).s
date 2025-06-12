    .data
buffer:          .byte  '________________________________'
buffer_pointer:  .word  0x00
buffer_start:    .word  0x00
buffer_size:     .word  0x1F
buffer_step:     .word  0x01
 
byte_shift:      .word  8
byte_mask:       .word  0xFF
current_character: .word  0x00
 
input_start:     .word  0x80
output_start:    .word  0x84
 
input_terminator: .word  0x0A
string_terminator: .word  0x00
string_space:    .word  0x20
error_placeholder: .word  0xCCCCCCCC
 
capitalize_next_flag: .word  0x01
true:            .word  0x01
false:           .word  0x00
 
case_constant:   .word  32
capitalize_upper_bound: .word  0x7A
capitalize_lower_bound: .word  0x61
minimize_lower_bound: .word  0x41
minimize_upper_bound: .word  0x5A
 
    .text
    .org         0x74                        ; 1 BYTE WASTED [127] :(
_start:
    load         true
    store        capitalize_next_flag
    jmp          setup
 
    .text
    .org         0x88
setup:
    load         buffer_start                ; Reset buffer pointer
    store        buffer_pointer
 
main_loop:
    load         buffer_size
    sub          buffer_pointer
    ble          exit_failure
 
    load_ind     input_start
    store        current_character
 
    sub          minimize_lower_bound
    ble          skip_forced_minimization
 
    load         current_character
    sub          minimize_upper_bound
    bgt          skip_forced_minimization
 
forced_minimization:
    load         current_character
    add          case_constant
    store        current_character
 
skip_forced_minimization:
    load         current_character
    sub          input_terminator
    beqz         end_input
 
    load         capitalize_next_flag
    beqz         set_capitalize_next
 
capitalize:
    load         false                       ; Clear flag
    store        capitalize_next_flag
 
    load         current_character           ; Skip if below 'a'
    sub          capitalize_lower_bound
    ble          set_capitalize_next
 
    load         current_character           ; Skip if above 'z'
    sub          capitalize_upper_bound
    bgt          set_capitalize_next
 
    load         current_character           ; Convert to uppercase
    sub          case_constant
    store        current_character
    jmp          update_buffer_pointer
 
set_capitalize_next:
    load         current_character
    sub          string_space
    bnez         update_buffer_pointer
set_capitalize_next_true:
    load         true
    store        capitalize_next_flag
    jmp          update_buffer_pointer
 
end_input:
    load_ind     buffer_pointer
    shiftr       byte_shift
    shiftl       byte_shift
    add          string_terminator
    store_ind    buffer_pointer
 
    jmp          exit
 
update_buffer_pointer:
    load_ind     buffer_pointer
 
    ; Duplicate logic. Lack of 'call' instruction is at fault.
    ; Chosen performance over "clean" code here.
 
    shiftr       byte_shift
    shiftl       byte_shift
    add          current_character
    store_ind    buffer_pointer
 
    load         buffer_pointer
    add          buffer_step
    store        buffer_pointer
 
    jmp          main_loop
 
exit:
    load         buffer_start
    store        buffer_pointer
 
output_write_loop:
    load_ind     buffer_pointer
    and          byte_mask
    beqz         exit_hlt
    store_ind    output_start
 
    load         buffer_pointer
    add          buffer_step
    store        buffer_pointer
 
    jmp          output_write_loop
 
exit_failure:
    load         error_placeholder
    store_ind    output_start
 
exit_hlt:
    halt

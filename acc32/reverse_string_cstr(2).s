.data
buffer:          .byte  '________________________________' 
buffer_pointer:  .word  0x00
input_addr:      .word  0x80               
output_addr:     .word  0x84   
new_line:        .word  0xA
tmp:             .word  0x0
tmp2:            .word  0x0
const_1:         .word  0x01  
const_0:         .word  0x00
mask:            .word  0xFFFF_FF00 
mask_small_byte: .word  0xFF 
buffer_size:     .word  0x20
error:           .word  0xCCCC_CCCC
null_term:       .word  0x0
left_ptr:        .word  0x0
right_ptr:       .word  0x0   
 
    .text
.org 0x200
_start:
 
read_loop:
    load_ind       input_addr
    store_addr     tmp
    sub            new_line
    beqz           store_null_terminator
 
    load_addr      buffer_pointer
    sub            buffer_size
    add            const_1
    beqz           buffer_overflow
 
    load_ind       buffer_pointer
    and            mask
    or             tmp
    store_ind      buffer_pointer
 
    load_addr      buffer_pointer 
    add            const_1
    store_addr     buffer_pointer
 
    jmp read_loop
 
store_null_terminator:
    load_ind       buffer_pointer 
    and            mask
    or             null_term
    store_ind      buffer_pointer
 
scan_for_zero:
    load_ind       right_ptr
    and            mask_small_byte
    beqz           prepare_reverse
 
    load_addr      right_ptr
    add            const_1
    store_addr     right_ptr
    jmp            scan_for_zero
 
prepare_reverse:
    load_addr      right_ptr
    sub            const_1
    store_addr      right_ptr
 
reverse_loop:
    load_addr       left_ptr
    sub             right_ptr
    ble             swap_chars
    jmp             start_printing
 
swap_chars:      
    load_ind        left_ptr
    and             mask_small_byte
    store_addr      tmp
 
    load_ind        right_ptr
    and             mask_small_byte
    store_addr      tmp2
 
    load_ind       left_ptr 
    and            mask
    or             tmp2
    store_ind      left_ptr
 
    load_ind       right_ptr 
    and            mask
    or             tmp
    store_ind      right_ptr
 
    load_addr      left_ptr 
    add            const_1
    store_addr      left_ptr
 
    load_addr      right_ptr 
    sub            const_1
    store_addr      right_ptr
 
    jmp reverse_loop
 
start_printing:
    load_addr      const_0
    store_addr     buffer_pointer
 
print_loop:
    load_ind       buffer_pointer
    and            mask_small_byte
    beqz           end
 
    store_ind      output_addr
    load_addr      buffer_pointer
    add            const_1
    store_addr     buffer_pointer
    jmp            print_loop
 
buffer_overflow:
    load_addr      error
    store_ind      output_addr
end:
    halt

    .data
buffer:             .byte 0, '_______________________________'
input_addr:         .word 0x80
output_addr:        .word 0x84
cap_case_diff:      .word 32
pointer:        	.word 0x0
len_counter:        .word 0x0
temp:               .word 0x0
mask:               .word 0xFFFFFF00
byte_mask:          .word 0xFF
symbols_limit:      .word 32
const_1:            .word 1
letter_a:           .word 'a'
letter_z:           .word 'z'
new_line:           .word 0xA
space:              .word ' '
 
    .text
    .org            0x88
 
_start:
    load_imm	buffer
    add         const_1
    store_addr  pointer
 
read:
    load_ind    input_addr
    and         byte_mask
    store_addr  temp
 
    sub         new_line
    beqz        store_len
 
to_upper:
    load_addr   temp
    sub         letter_a
    ble         store_temp
 
    load_addr   temp
    sub         letter_z
    bgt         store_temp
 
    load_addr   temp
    sub         space
    beqz        store_temp 
 
    load_addr   temp
    sub         cap_case_diff
    store_addr  temp
 
store_temp:
    load_ind    pointer
    and         mask
    or          temp
    store_ind   pointer
 
    load_addr   pointer
    add         const_1
    store_addr  pointer
 
    load_addr   len_counter
    add         const_1
    store_addr  len_counter
	and 		byte_mask
	sub         symbols_limit
    beqz        overflow
 
    jmp         read      
 
 
store_len:
    load		buffer
    and         mask
    or          len_counter
    store		buffer
 
    load_imm	buffer
    add         const_1
    store_addr  pointer
 
    load_addr   len_counter
 
print_while:
    load_ind    pointer
    and         byte_mask
    store_ind   output_addr
 
    load_addr   pointer
    add         const_1
    store_addr  pointer
 
    load_addr   len_counter
    sub         const_1
	beqz        end
    store_addr  len_counter
 
    jmp         print_while
 
overflow:
    load_imm     0xCCCC_CCCC
    store_ind    output_addr
end:
    halt

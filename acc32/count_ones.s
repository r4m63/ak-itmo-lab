.data
input_addr:      .word  0x80
output_addr:     .word  0x84
num:             .word  0x00
mask:            .word  1
count:           .word  0
const_c:         .word  1
 
.text
_start:
    load_ind input_addr
    store num
    beqz end_count
    load mask
 
loop:
    beqz end_count
    and num
    beqz next_bit
 
    load count
    add const_c
    store count
 
next_bit:
    load mask
    shiftl const_c
    store mask
    jmp loop
 
 
end_count:
    add const_c
    store mask
    load count
    store_ind output_addr
    halt

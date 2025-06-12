.data
input_addr:   .word 0x80
output_addr:  .word 0x84
low_part:     .word 0x00
high_part:    .word 0x00
tmp_value:   .word 0x00
const_1:      .word 0x01
const_minus_1:     .word 0xFFFFFFFF
 
.text
 
_start:
    load_ind  input_addr
    beqz      end_of_programm
    store     tmp_value
 
    ble       sign_ext
 
skip_sign:
    load      tmp_value
    add       low_part
    store     low_part
    bcs       increment_high
    jmp       _start
 
sign_ext:
    load      high_part
    add       const_minus_1
    store     high_part
    jmp       skip_sign
 
increment_high:
    load      high_part
    add       const_1
    store     high_part
    jmp       _start
 
end_of_programm:
    load      high_part
    store_ind output_addr
    load      low_part
    store_ind output_addr
    halt

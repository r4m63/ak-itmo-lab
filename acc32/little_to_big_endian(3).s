.data
 
input_addr:         .word 0x80
output_addr:        .word 0x84
 
input_value:        .word 0
output_value:       .word 0
 
counter:            .word 4
const_FF:           .word 0xFF
const_one:          .word 1
const_eight:        .word 8
 
shift_in_bits_L:    .word 24
shift_in_bits_R:    .word 0
 
.text
 
_start:
get_input_value:
    load_ind    input_addr          ; acc <-- mem[mem[input_addr]]
    store       input_value
    load        counter             ; acc <-- counter
 
reverse_bytes_loop:
    beqz        print_output        ; while (counter != 0) {
 
    load        input_value         
    shiftr      shift_in_bits_R     ; input_value >> mem[shifts_in_bits_R]
    and         const_FF            ; input_value & 0xFF (get the last byte)
    shiftl      shift_in_bits_L     ; input_value << mem[shifts_in_bits_L]
    or          output_value
    store       output_value
 
    load        shift_in_bits_L
    sub         const_eight         ; shift_in_bits_L -= 8
    store       shift_in_bits_L
 
    load        shift_in_bits_R
    add         const_eight         ; shift_in_bits_R += 8
    store       shift_in_bits_R
 
    load        counter
    sub         const_one
    store       counter
 
    jmp         reverse_bytes_loop  ; }
 
print_output:
    load        output_value
    store_ind   output_addr
 
end:
    halt

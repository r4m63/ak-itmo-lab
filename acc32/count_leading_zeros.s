.data
input_addr:   .word  0x80
output_addr:  .word  0x84
n:            .word  0
count:        .word  0
const_1:      .word  1
mask:         .word  0x80000000     ; most significant bit
 
.text
_start:
    load_ind     input_addr
    store        n
    beqz         handle_zero        ; if n == 0 → result is 32
    load_imm     0
    store        count
 
loop:
    load         n
    and          mask
    bnez         done               ; if MSB is 1 → stop
    load         count
    add          const_1
    store        count
    load         n
    shiftl       const_1
    store        n
    jmp          loop
 
handle_zero:
    load_imm     32
    store_ind    output_addr
    halt
 
done:
    load         count
    store_ind    output_addr
    halt

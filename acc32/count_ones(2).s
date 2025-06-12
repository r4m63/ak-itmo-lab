    .data
 
input_addr:      .word  0x80               ; input
output_addr:     .word  0x84               ; output
n:               .word  0x00               ; input variable
number_of_ones:  .word  0x00               ; counter for ones
i:               .word  0x00               ; var for loops
one:             .word  0x01               ; const for bitwise AND & shift & decrement
 
 
    .text
.org 0x88
 
_start:
    load_ind     input_addr                  ; acc = *input_addr
    store        n                           ; n = acc
 
revert_n:
    load_imm     32                          ; counter for loop
    store        i                           ; i = 32
 
loop:
    load         i                           ; acc = i
    beqz         end_loop                    ; i == 0 ? -> end_loop
    sub          one                         ; i--
    store        i                           ; save i
 
    load         n                           ; load n
    and          one                         ; n & 0x1
    add          number_of_ones              ; number_of_ones += n & 0x1
    store        number_of_ones
    load         n
    shiftr       one
    store        n
 
    jmp          loop                        ; next iteration
 
end_loop:
    load         number_of_ones              ; acc = number_of_ones
    store_ind    output_addr
    halt

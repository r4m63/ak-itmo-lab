    .data


first_word:      .word  0
second_word:     .word  0
i:               .word  0
input_addr:      .word  0x80
output_addr:     .word  0x84
const_1:         .word  1
const_minus_1:   .word  -1
const_minus:     .word  0x80000000
input_word:      .word  0

    .text

_start:

    load_ind     input_addr
    store        i                           ; i <- n

while:

    beqz         end                         ; while (i != 0) {

    load_ind     input_addr
    store        input_word
    add          first_word
    store        first_word                  ; first_word <- *input_addr + first_word

    bcc          minus
    load         second_word
    add          const_1
    store        second_word                 ; second_word <- 1 + second_word

minus:

    load         input_word
    and          const_minus
    beqz         continue
    load         second_word
    add          const_minus_1
    store        second_word

continue:

    load         i
    sub          const_1
    store        i                           ; i <- i - const_1

    jmp          while                       ; }

end:

    load         second_word
    store_ind    output_addr

    load         first_word
    store_ind    output_addr

    halt
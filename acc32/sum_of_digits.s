    .data
 
input_addr:      .word  0x80               ;Input adress where the number 'n' is stored
output_addr:     .word  0x84               ;Output adress where the result is stored
n:               .word  0x00               ;Variable for n
result:          .word  0x00               ;variable to store the sum of digits
divisor:         .word  10
negmult:         .word  -1
 
    .text
_start:
    load_ind     input_addr                  ;load value at input address to acc
    ble          negative_case
    jmp          done
negative_case:
    mul          negmult
done:
    store        n
n_while:
    beqz         end                         ; if (n = 0) goto end
    rem          divisor                     ; acc % 10
    add          result                      ; acc = (acc % 10) + result
    store        result                      ; result = ((acc % 10) + result)
    load         n
    div          divisor
    store        n
    jmp          n_while
end:
    load         result
    store_ind    output_addr
    halt

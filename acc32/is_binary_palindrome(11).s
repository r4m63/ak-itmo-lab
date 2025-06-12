    .data
input:           .word  0x80
output:          .word  0x84
tmp:             .word  0x00
count:           .word  0x00
base:            .word  2
four:            .word  4
n:               .word  0x00
second_pointer:  .word  0x00
arr_base:        .word  0x100
first_pointer:   .word  0x100
 
    .text
    .org         0x180
_start:
    load_ind     input                       ; acc = *input
    store_addr   n                           ; n = acc
 
cycle:
    load_addr    arr_base                    ; acc = arr_base
    store_addr   tmp                         ; tmp = acc (arr_base)
    load_addr    count                       ; acc = count
    mul          four
    add          tmp                         ; acc = count + arr_base
    store_addr   tmp                         ; tmp = acc (count + arr_base)
 
    load_addr    n                           ; acc = n
    rem          base                        ; acc = n%2
    store_ind    tmp                         ; mem[tmp] = acc
 
    load_addr    n
    div          base
    store_addr   n
 
    load_imm     31
    xor          count
    beqz         prepare_to_check
 
    load_imm     1
    add          count
    store_addr   count
    jmp          cycle
 
prepare_to_check:
    load_addr    arr_base
    store_addr   tmp
    load_addr    count
    mul          four
    add          tmp
    store_addr   second_pointer
 
check:
    load_addr    second_pointer
    sub          first_pointer
    beqz         true
    store_addr   tmp
    load_imm     4
    sub          tmp
    beqz         true
 
 
    load_ind     first_pointer
    store_addr   tmp
    load_ind     second_pointer
    xor          tmp
    bnez         false
 
    load_imm     4
    store_addr   tmp
 
    add          first_pointer
    store_addr   first_pointer
    load_addr    second_pointer
    sub          tmp
    store_addr   second_pointer
    jmp          check
true:
    load_imm     1
    store_ind    output
    halt
false:
    load_imm     0
    store_ind    output
    halt

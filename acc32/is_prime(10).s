.data
input_addr:     .word 0x80        ; адрес входного значения
output_addr:    .word 0x84        ; адрес для результата
 
number:         .word 0           ; копия входного значения n
one:            .word 1           ; константа 1
two:            .word 2           ; константа 2
neg_one:        .word -1          ; константа -1 для ошибок
zero:           .word 0           ; константа 0
 
i:              .word 0           ; переменная счётчик
number_div_i:   .word 0           ; для проверки окончания числа
 
.org 0x100
.text
 
_start:
    load_ind input_addr
    store number
 
    ; if number == 0 → -1
    load number
    beqz input_error
 
    ; if number < 0 → -1
    ble input_error
 
    ; if number == 1 → 0
    sub one
    beqz return_not_prime
 
    ; if number == 2 → 1
    load number
    sub two
    beqz return_prime
 
    ; if number % 2 == 0 → 0
    load number
    rem two
    beqz return_not_prime
 
    ; i = 3
    load two
    add one
    store i
 
loop:
    ; if i > number / i → return_prime
    load number
    div i
    store number_div_i
 
    load i
    sub number_div_i
    bgt return_prime
 
    ; if number % i == 0 → 0
    load number
    rem i
    beqz return_not_prime
 
    ; i = i + 2
    load i
    add two
    store i
 
    jmp loop
 
return_prime:
    load one
    store_ind output_addr
    halt
 
return_not_prime:
    load zero
    store_ind output_addr
    halt
 
input_error:
    load neg_one
    store_ind output_addr
    halt

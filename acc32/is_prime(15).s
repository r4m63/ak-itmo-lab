.data
input_addr:       .word 0x80
output_addr:      .word 0x84
num:              .word 0
const_one:        .word 1
const_two:        .word 2
const_minus_one:  .word -1
const_zero:       .word 0
quotient:         .word 1
mean:             .word 0
divisor:          .word 2
 
.text
    .org 0x88
_start:
    ; Загрузить входное число
    load_ind    input_addr
    store       num
    store       mean
 
    ; Проверка числа на <= 1
    sub         const_one       ; num - 1
    beqz        not_prime       ; если num == 1 -> не простое
    ble         write_minus_one ; если num < 1 -> ошибка (-1)
 
; Вычисление приближенного квадратного корня (метод средних)
calc_sqrt:
    load        quotient
    sub         mean
    beqz        check_divisors
    bgt         check_divisors
 
    load        mean
    add         quotient
    shiftr      const_one       ; (mean + quotient) / 2
    store       mean
 
    load        num
    div         mean
    store       quotient
 
    jmp         calc_sqrt
 
; Цикл проверки делителей от 2 до sqrt(num)
check_divisors:
    load        divisor
    sub         mean
    bgt         prime           ; если divisor > mean -> число простое
 
    load        num
    rem         divisor
    beqz        not_prime       ; если num % divisor == 0 -> не простое
 
    load        divisor
    add         const_one
    store       divisor
 
    jmp         check_divisors
 
; Возврат результатов
write_minus_one:
    load        const_minus_one
    jmp         return_result
 
prime:
    load        const_one
    jmp         return_result
 
not_prime:
    load        const_zero
    jmp         return_result
 
return_result:
    store_ind   output_addr
    halt

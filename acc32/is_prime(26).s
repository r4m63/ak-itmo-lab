    .data
 
input_addr:      .word  0x80               ; Адрес ввода
output_addr:     .word  0x84               ; Адрес вывода
n:               .word  0x00               ; Число n
i:               .word  0x02               ; Счётчик цикла
sqrt_n:          .word  0x00               ; Корень из n
const_0:         .word  0x00               ; Константа 0
const_1:         .word  0x01               ; Константа 1
const_2:         .word  0x02               ; Константа 2
result:          .word  0x01               ; Результат (1 — простое, 0 — нет, -1 — ошибка)
guess:           .word  0x00               ; Текущее приближение для sqrt(n)
new_guess:       .word  0x00               ; Новое приближение для sqrt(n)
 
    .text
.org 0x90
_start:
    ; Загрузка входного значения
    load_ind     input_addr                  ; acc = mem[mem[input_addr]]
    store        n                           ; mem[n] = acc
 
    ; Проверка: если n < 1, ошибка
    load         n                           ; acc = n
    sub          const_1                     ; acc = n - 1
    ble          not_in_domain               ; если n - 1 <= 0 (n <= 1), переход
 
    ; Проверка: если n == 1, не простое
    load         n                           ; acc = n
    sub          const_1                     ; acc = n - 1
    beqz         is_not_prime                ; если n - 1 == 0 (n == 1), переход
 
    ; Вычисление sqrt(n) методом Ньютона
    ; Начальное приближение: n / 2 + 1
    load         n                           ; acc = n
    div          const_2                     ; acc = n / 2
    add          const_1                     ; acc = (n / 2) + 1
    store        guess                       ; guess = (n / 2) + 1
 
sqrt_iteration:
    ; Новое приближение: (guess + n / guess) / 2
    load         n                           ; acc = n
    div          guess                       ; acc = n / guess
    add          guess                       ; acc = guess + (n / guess)
    div          const_2                     ; acc = (guess + (n / guess)) / 2
    store        new_guess                   ; new_guess = acc
 
    ; Проверка сходимости: |new_guess - guess| <= 1
    load         new_guess                   ; acc = new_guess
    sub          guess                       ; acc = new_guess - guess
    bgt          check_negative_diff         ; если разница > 0, проверить отрицательную
    load         guess                       ; иначе acc = guess - new_guess
    sub          new_guess                   ; acc = guess - new_guess
check_negative_diff:
    sub          const_2                     ; acc = |разница| - 2
    ble          sqrt_done                   ; если |разница| < 2 (то есть <= 1), выход
 
    ; Обновляем guess и продолжаем
    load         new_guess                   ; acc = new_guess
    store        guess                       ; guess = new_guess
    jmp          sqrt_iteration              ; следующая итерация
 
sqrt_done:
    load         guess                       ; acc = guess
    store        sqrt_n                      ; sqrt_n = guess
 
    ; Инициализация i = 2
    load         const_2                     ; acc = 2
    store        i                           ; mem[i] = 2
 
prime_check_loop:
    ; Проверка: i > sqrt_n
    load         i                           ; acc = i
    sub          sqrt_n                      ; acc = i - sqrt_n
    bgt          is_prime                    ; если i > sqrt_n, число простое
 
    ; Проверка: n % i == 0
    load         n                           ; acc = n
    rem          i                           ; acc = n % i
    beqz         is_not_prime                ; если остаток == 0, число не простое
 
    ; Инкремент счетчика
    load         i                           ; acc = i
    add          const_1                     ; acc = i + 1
    store        i                           ; mem[i] = acc
    jmp          prime_check_loop            ; следующий шаг цикла
 
is_prime:
    load_imm     1                           ; результат = 1 (простое)
    store        result
    jmp          store_result
 
is_not_prime:
    load_imm     0                           ; результат = 0 (не простое)
    store        result
    jmp          store_result
 
not_in_domain:
    load_imm     -1                          ; результат = -1 (ошибка)
    store        result
 
store_result:
    load         result                      ; acc = результат
    store_ind    output_addr                 ; сохраняем по адресу вывода
    halt

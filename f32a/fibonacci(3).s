.data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
.text
 
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
_start:
    .org 0x88
    @p input_addr a! @       \ читаем n из input_addr
 
    fib_main
 
    @p output_addr a! !      \ записываем результат в output_addr
    halt
 
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
\ A — счётчик
fib_main:
    \ если n == 0
    dup
    if fib_ret_zero
 
    \ если n < 0
    dup
    inv
    -if fib_ret_neg
 
    \ если n >= 3
    dup
    lit -3
    +
    -if fib_compute
 
    \ если n <= 2
    lit 1
    fib_end ;
 
fib_compute:
    \ n -= 2, сохраняем в A
    dup
    lit -2
    +
    a!
    drop
 
    \ инициализируем первые два числа Фибоначчи
    lit 1
    lit 1
 
fib_loop:
    a
    if fib_end            \ если счётчик A == 0, выходим
 
    \ вычисляем сумму двух последних чисел
    over
    >r
    dup
    r>
    +
 
    \ уменьшаем A на 1
    a
    lit -1
    +
    a!
 
    \ проверка A >= 0
    dup
    -if fib_loop
 
    fib_ret_overflow ;
 
fib_ret_neg:
    lit -1
    fib_end ;
 
fib_ret_zero:
    lit 0
    fib_end ;
 
fib_ret_overflow:
    drop
    lit 0xCCCCCCCC
    fib_end ;
 
fib_end:
    over
    drop
    ;                      \ возврат

    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
_start:
    \ — Загрузим n
    @p input_addr a! @          \ — n:[]
 
    count_zero
 
    \ — Запишем результат
    @p output_addr a! !         \ — [cnt] → output_addr
    halt
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
count_zero:
    lit 0 a!                     
 
    lit 31 >r                    \ «Будем жать next 32 раза»
 
cz_loop:
    dup                          \ … n:n
 
    lit 1 and                    \ … n:(n&1)
 
    \ — Если бит = 0, прыгаем на метку cz_inc
    if cz_inc
 
    \ — Иначе — пропускаем инкремент
    skip_cz_inc ;
 
cz_inc:
    a                            \ … cnt
    lit 1                        \ … cnt:1
    +                            \ … cnt+1
    a!                           \ A ← cnt+1
 
skip_cz_inc:
    2/                           \ … n:=n>>1
 
    \ — Декремент R, если ещё не 0 — прыгнем на cz_loop
    next cz_loop
 
    a                            \ … cnt
 
    ;                            \ return

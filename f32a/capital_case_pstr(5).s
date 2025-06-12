    .data
 
buf:             .byte  '____________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
    .org 0x100
 
_start:
    @p input_addr b!         \ B <- mem[input_addr]; отправили инпут в B
 
    lit buf																		\ T <- buf
    lit 1 + a!               \ A <- 1 + T; отправили адресс буфера + 1 в A
 
    lit 0x20                 \ T <- 32; размер буфера
    lit 0 over               \ T <- 0; S <-> T; флажок ставим
 
read_input:
    dup																						\ S <- T
    if overflow              \ if T == 0 go to overflow
    over																					\ S <-> T
 
    @b lit 255 and           \ T <- (mem[B] & 255); последний байт слова
 
    dup lit -10 +												\ T <- (T - 10)
    if end_of_input          \ if T == 0 go to end_of_input; нашли '\n'
 
    check_symbol             \ проверяем регистр
 
    over                     \ после функций имеем: [символ, флаг, счетчик]
 
    lit 0x5f5f5f00 +         \ маска для сохранения
    !+                       \ mem[A] <- T; A <- A + 1
    over 																				\ T <-> S
 
    lit -1 +                 \ capacity -= 1
    read_input 														\ читаем по новой
    ;                        \ выходим
 
end_of_input:
    drop                     \ null <- T; убрали \n
    drop                     \ null <- T; убрали флаг
    dup lit -32 +            \ T <- (T - 32)
    if overflow														\ if T == 0 go to overflow; буфер пуст
    lit 0x1f xor													\ T <- (T xor 31)
    lit 1 +                  \ T <- (T + 1); прочитали столько символов
 
    lit buf a!															\ A <- buf
    @ lit 0xffffff00 and     \ помещаем количетсво прочитанных в начало строки
    + !																						\ mem[A] <- (T + S)
 
go_to_output:
    @p output_addr b!        \ B <- 0x84
    lit buf a!               \ A <- 0x00
    @+ lit 255 and           \ количетсво прочитанных
 
output_1:
    dup																						\ S <- T
    if end 																		\ if T == 0 go to end
 
    @+ lit 255 and           \ mem[A] & 0x000000ff
    !b                       \ пишем символ
 
    lit -1 +																	\ T <- (T - 1)
    output_1																	\ go to output_1
    ;
 
end:
    halt
 
overflow:
    @p output_addr b!								\ B <- output_addr
    lit -858993460 !b        \ ошибочка
    end
 
 
check_symbol:
    \ проверяем надо ли ПОДНИМАТЬ МОТИВАЦИЮ символу
    dup lit -32 +												\ T <- (T - 32)
    if space         								\ если пробел обновляем флаг
    over 																				\ T <-> S
    if need_to_capitalize    \ если 0, то поднимаем мотивацию
 
decapitalize:
				\ понижаем МОТИВАЦИЮ символа
    dup lit -65 +            \ T <- (T - 65)
    -if upper_than_A         \ if код символа >= кода 'A'
    ret_with_1_flag										\ ставим флаг 1
    ;								 															\ выходим
 
upper_than_A:
    dup lit -91 +												\ T <- (T - 91)
    -if ret_with_1_flag      \ if код символа > 'Z' не понижаем
    lit 32 +                 \ T <- (T + 32); понижаем
    ret_with_1_flag										\ меняем флаг
    ;								 															\ выходим
 
need_to_capitalize:
    dup lit -97 +												\ T <- (T - 97)
    -if upper_than_a         \ if код символа >= кода 'a'
    ret_with_1_flag										\ меняем флаг
    ;								 															\ выходим
 
upper_than_a:
    dup lit -123 +											\ T <- (T - 123)
    -if ret_with_1_flag      \ if код символа >'z' не поднимаем
    lit -32 +																\ T <- (T + 32)
    ret_with_1_flag										\ меняем флаг
    ;								 															\ выходим      
 
space:
    over drop lit 0									 \ null <- S; T <- 0; ставим флаг 0
    ;								 															\ выходим
 
 
ret_with_1_flag:
    lit 1                    \ ставим флаг 1
    ;								 															\ выходим

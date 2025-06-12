.data
count:          .byte 0               \ Счётчик символов
buf:            .byte '________________________________' \ Буфер
after_buf:      .byte '___'           \ Дополнительное пространство
input_addr:     .word 0x80            \ Адрес ввода
output_addr:    .word 0x84            \ Адрес вывода
flag:           .word 0x00            \ Флаг для пробела
overflow_val:   .word -858993460      \ Значение переполнения
 
.text
.org 0x99
_start:
    lit buf           \ Адрес буфера
    a!                \ Установить регистр A
    lit 32            \ Пробел
    !p flag           \ Инициализировать флаг
    @p input_addr     \ Адрес ввода
    b!                \ Установить регистр B
 
read_loop:
    @p count          \ Проверка счётчика
    lit 0xFF          \ Маска 8 бит
    and
    lit -32           \ Проверка на переполнение
    + 
    -if overflow      \ Если count >= 32
 
    @b                \ Чтение байта
    dup
    lit -10           \ Проверка на новую строку
    + 
    if end            \ Если байт = 10
 
    @p flag           \ Проверка флага
    lit -32           \ Был пробел?
    + 
    if upper_case     \ Если да
 
    dup               \ Проверка на пробел
    lit -32
    + 
    if process_space_char
 
    lower_case ;      \ Обработка символа
 
process_space_char:
    dup               \ Установить флаг
    !p flag
    store_char        \ Сохранить пробел
    read_loop ;
 
upper_case:
    dup dup dup       \ Проверка диапазона 'a'-'z'
    lit -122          \ <= 'z'?
    + 
    -if skip_transform
    lit -97           \ >= 'a'?
    + 
    inv 
    lit 1 
    + 
    -if skip_transform
    lit -32           \ В верхний регистр
    + 
continue:
    lit 0             \ Сброс флага
    !p flag
    store_char        \ Сохранить символ
    read_loop ;
 
skip_transform:
    drop
    continue ;
 
lower_case:
    dup               \ Проверка диапазона 'A'-'Z'
    lit -122          \ <= 'z'?
    + 
    -if continue_lower
 
    dup
    lit -65           \ >= 'A'?
    + 
    inv 
    lit 1 
    + 
    -if continue_lower
 
    dup
    lit -90           \ <= 'Z'?
    + 
    inv 
    lit 1 
    + 
    -if transform_to_lower
 
continue_lower:
    store_char        \ Сохранить символ
    read_loop ;
 
transform_to_lower:
    lit 32            \ В нижний регистр
    + 
    continue_lower ;
 
store_char:
    !+                \ Записать в буфер
    @p count          \ Увеличить счётчик
    lit 1 
    + 
    !p count 
    ;
 
end:
    lit 0x5F5F5F5F    \ Маркер конца
    !+                \ Записать в буфер
    lit buf           \ Адрес буфера
    a!
    @p output_addr    \ Адрес вывода
    b!
    print             \ Вывод
    drop
    halt              \ Стоп
 
print:
    @+                \ Чтение из буфера
    lit 0xFF          \ Маска 8 бит
    and 
    !b                \ Запись в вывод
    @p count          \ Проверка счётчика
    lit 0xFF
    and 
    a                 \ Адрес буфера
    inv 
    lit 1 
    + 
    + 
    -if print         \ Продолжить, если не конец
    ;
 
overflow:
    @p output_addr    \ Адрес вывода
    b!
    @p overflow_val   \ Значение переполнения
    !b                \ Записать
    halt              \ Стоп

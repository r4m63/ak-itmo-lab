.data
input_addr:     .word 0x80
output_addr:    .word 0x84
main_mask:      .word 0x80000001
counter:        .word 0x10
low_mask:       .word 0x0000FFFF
up_mask:        .word 0xFFFF0000
ones_mask:      .word 0x7FFFFFFF
temp_addr:      .word 0x90
 
.text
.org 0x200
 
_start:
    @p input_addr a! @      \ загрузили число в стек
 
    dup
    @p up_mask and
    a!                      \ старшие 16 бит -> регистр A
 
    dup
    @p low_mask and
    !p temp_addr            \ младшие 16 бит -> память по temp_addr
 
 
check_loop:
    @p counter              \ проверяем счетчик
 
    dup
    if palindrome           \ если счетчик == 0 -> конец
 
    lit -1 +                \ уменьшаем счетчик
 
    !p counter
 
    @p temp_addr            \ загружаем младшие биты в стек
    a                       \ загружаем старшие биты в стек
 
    +                       \ складываем младшие + старшие
    @p main_mask            \ применяем маску
    and                     \ оставляем только крайние биты
 
    dup
    if next_shift           \ проверяем, что получили 0...0
    dup
    @p ones_mask
    +
    if next_shift           \ проверяем, что получили 1...1
 
not_palindrome:
    lit 0 @p output_addr a! !
    halt
 
next_shift:
    @p temp_addr            \ загружаем младшие биты
    2/                      \ сдвигаем вправо
    !p temp_addr            \ сохраняем обратно в память
 
    a 2*                    \ старшие биты сдвигаем влево
    a!                      \ сохраняем обратно в A
 
    check_loop ;
 
palindrome:
    lit 1 @p output_addr a! !
    halt

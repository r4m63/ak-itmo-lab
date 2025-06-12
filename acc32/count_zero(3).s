    .data
 
    ; Константы и переменные
input_addr:      .word  0x80               ; Адрес ввода
output_addr:     .word  0x84               ; Адрес вывода
mask_1:          .word  0x01               ; Маска для младшего бита
shift_1:         .word  0x01               ; Сдвиг на 1 бит
loop_count_init: .word  0x20               ; 32 итерации (в hex)
temp:            .word  0x00               ; Временное хранение числа
zeros_cnt:       .word  0x00               ; Счетчик нулей
loop_count:      .word  0x00               ; Динамический счетчик циклов
 
    .text
 
_start:
    ; Инициализация
    load_ind     input_addr                  ; Загрузка входного числа
    store        temp                        ; Сохраняем во временную переменную
 
    load_imm     0
    store        zeros_cnt                   ; Инициализация счетчика нулей
 
    load         loop_count_init
    store        loop_count                  ; Установка счетчика циклов
 
main_loop:
    ; Проверка на завершение цикла
    load         loop_count
    beqz         loop_end
 
    ; Проверка младшего бита
    load         temp
    and          mask_1
    beqz         increment_count
 
shift_right:
    load         temp
    shiftr       shift_1                     ; Сдвиг вправо
    store        temp
 
    load         loop_count
    sub          mask_1                      ; Декремент счетчика
    store        loop_count
 
    jmp          main_loop
 
increment_count:
    load         zeros_cnt
    add          mask_1                      ; Увеличиваем счетчик
    store        zeros_cnt
    jmp          shift_right
 
loop_end:
    load         zeros_cnt
    store_ind    output_addr                 ; Запись в выходной адрес
    halt

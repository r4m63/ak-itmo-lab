.data
buf:                .byte   '________________________________'
str1:               .byte   7
str1_:              .byte   'Hello, '
str2:               .byte   1
str2_:              .byte   '!'
str3:               .byte   19
str3_:              .byte   'What is your name?\n'
input_addr:         .word   0x80
output_addr:        .word   0x84
eof:                .word   0xA
buf_start_addr:     .word   0x0
buf_size_bytes:     .word   0x20
overflow_value:     .word   0xCCCC_CCCC
init_sp_value:      .word   0x1000  
 
.text
.org 0x100
_start:
    lui     sp, %hi(init_sp_value)              ; Загрузка начального значения указателя стека
    addi    sp, sp, %lo(init_sp_value)
    lw      sp, 0(sp)
    lui     s1, %hi(buf_start_addr)             ; Загрузка начального адреса буфера в s1
    addi    s1, s1, %lo(buf_start_addr)
    lw      s1, 0(s1)
    lui     s2, %hi(buf_size_bytes)             ; Загрузка размера буфера в s2
    addi    s2, s2, %lo(buf_size_bytes)
    lw      s2, 0(s2)
    lui     a0, %hi(str1)                       ; Вычитание длины str1 из размера буфера (s2)
    addi    a0, a0, %lo(str1)
    jal     ra, load_byte
    sub     s2, s2, a0
    lui     a0, %hi(str2)                       ; Вычитание длины str2 из размера буфера (s2)
    addi    a0, a0, %lo(str2)
    jal     ra, load_byte
    sub     s2, s2, a0
    addi    s2, s2, -1                          ; Вычитание 1 из размера буфера, так как нужен байт для длины
    lui     s3, %hi(output_addr)                ; Загрузка адреса вывода в s3
    addi    s3, s3, %lo(output_addr)
    lw      s3, 0(s3)
    lui     a0, %hi(str3)                       ; Вывод строки str3
    addi    a0, a0, %lo(str3)
    mv      a1, s3 
    jal     ra, print_pstr
    addi    a0, zero, 0                         ; Запись нуля в первый байт буфера (пустая Pascal-строка)
    mv      a1, s1
    jal     ra, store_byte
    mv      a0, s1                              ; Добавление str1 в буфер
    lui     a1, %hi(str1) 
    addi    a1, a1, %lo(str1)
    jal     ra, concate_pstrs                   ; После вызова a0 указывает на первый свободный элемент в буфере
    lui     a1, %hi(input_addr)                 ; Загрузка адреса ввода в a1
    addi    a1, a1, %lo(input_addr)
    lw      a1, 0(a1)
    lui     a2, %hi(eof)                        ; Загрузка символа конца ввода в a2
    addi    a2, a2, %lo(eof)
    lw      a2, 0(a2)
    mv      a3, s2                              ; Загрузка оставшегося размера буфера в a3
    jal     ra, read_data
    addi    t0, zero, -1                        ; Если a0 равно -1, переход к переполнению
    beq     a0, t0, overflow
    mv      s4, a0                              ; Сохранение длины полученной строки (a0) в s4 (для сохранения после вызова)
    mv      a0, s1                              ; Загрузка размера текущей строки в буфере (s1) в a0
    jal     ra, load_byte
    add     a0, a0, s4                          ; Суммирование длины полученной строки (s4) и текущей длины (a0)
    mv      a1, s1                              ; Запись новой длины строки (a0) в первый символ буфера (s1)
    jal     ra, store_byte
    mv      a0, s1                              ; Загрузка указателя на начало буфера в a0
    lui     a1, %hi(str2)                       ; Загрузка указателя на str2 в a1
    addi    a1, a1, %lo(str2)
    jal     ra, concate_pstrs                   ; Конкатенация str2 со строкой в буфере
    mv      a0, s1                              ; Вывод строки из буфера
    mv      a1, s3
    jal     ra, print_pstr
    halt
 
overflow:
    lui     t0, %hi(overflow_value)             ; Загрузка значения переполнения в t0
    addi    t0, t0, %lo(overflow_value)
    lw      t0, 0(t0)         
    sw      t0, 0(s3)                           ; Вывод t0
    halt
 
; Чтение данных из входного адреса и сохранение в буфер
; Чтение останавливается при достижении символа конца ввода или при переполнении буфера
; Аргументы
;   a0 -> указатель на буфер
;   a1 -> адрес ввода
;   a2 -> символ конца ввода
;   a3 -> размер буфера
; Возврат
;   a0 -> количество полученных символов или -1 при переполнении
read_data:
    addi    sp, sp, -32                         ; Сохранение регистров в стек
    sw      s0, 0(sp)
    sw      s1, 4(sp)
    sw      s2, 8(sp)
    sw      s3, 12(sp)
    sw      s4, 16(sp)
    mv      s0, a0                              ; Перемещение аргументов в регистры
    mv      s1, a1
    mv      s2, a2
    mv      s3, a3
    addi    s4, zero, 0                         ; Инициализация счетчика символов (s4)
    ; s0 -> указатель на текущую позицию в буфере
    ; s1 -> указатель на регистр ввода
    ; s2 -> символ конца ввода
    ; s3 -> длина буфера
    ; s4 -> количество полученных символов
read_data_cycle:
    beq     s3, s4, read_data_overflow          ; Если буфер полон, переход к переполнению
    lw      a0, 0(s1)                           ; Чтение нового символа
    beq     a0, s2, ret_read_data               ; Если получен символ конца ввода, возврат
    mv      a1, s0                              ; Сохранение полученного символа в буфер
    sw      ra, 20(sp)
    jal     ra, store_byte
    lw      ra, 20(sp)
    addi    s0, s0, 1                           ; Увеличение указателя буфера
    addi    s4, s4, 1                           ; Увеличение счетчика символов
    j       read_data_cycle                     ; Продолжение цикла
read_data_overflow:
    addi    s4, zero, -1                        ; Запись -1 в счетчик символов
ret_read_data:
    mv      a0, s4                              ; Запись количества полученных символов (s4) в a0
    lw      s0, 0(sp)                           ; Восстановление регистров
    lw      s1, 4(sp)
    lw      s2, 8(sp)
    lw      s3, 12(sp)
    lw      s4, 16(sp)
    addi    sp, sp, 32
    jr      ra                                  ; Возврат
 
; Вывод Pascal-строки
; Аргументы
;   a0 -> указатель на Pascal-строку
;   a1 -> адрес вывода
print_pstr:
    addi    sp, sp, -16                         ; Сохранение регистров в стек
    sw      s0, 0(sp)
    sw      s1, 4(sp)
    mv      s0, a0                              ; Перемещение аргументов в регистры
    mv      s1, a1
    sw      ra, 8(sp)                           ; Загрузка длины строки и сохранение в t0
    jal     ra, load_byte
    lw      ra, 8(sp)
    mv      t0, a0
    addi    s0, s0, 1                           ; Сдвиг указателя, так как длина не выводится
    ; t0 -> количество оставшихся символов
    ; s0 -> указатель на текущий символ
    ; s1 -> указатель на регистр вывода
print_cycle:
    beqz    t0, ret_print_pstr                  ; Если символов не осталось, возврат
    addi    t0, t0, -1                          ; Уменьшение t0
    lw      t1, 0(s0)                           ; Загрузка слова из текущей позиции
    sb      t1, 0(s1)                           ; Вывод нижнего байта
    addi    s0, s0, 1                           ; Увеличение указателя
    j       print_cycle                         ; Продолжение цикла
ret_print_pstr:
    lw      s0, 0(sp)                           ; Восстановление регистров
    lw      s1, 4(sp)
    addi    sp, sp, 16
    jr      ra                                  ; Возврат
 
; Добавление одной Pascal-строки к другой
; pstr1 += pstr2
; Длина обновляется автоматически
; Аргументы
;   a0 -> указатель на pstr1
;   a1 -> указатель на pstr2
; Возврат
;   a0 -> указатель на символ после конца pstr1
concate_pstrs:
    addi    sp, sp, -16                         ; Сохранение регистров в стек
    sw      s0, 0(sp)
    sw      s1, 4(sp)
    sw      s2, 8(sp)
    mv      s0, a0                              ; Перемещение аргументов в регистры
    mv      s1, a1
    mv      a0, s1                              ; Загрузка длины pstr2 в s2
    sw      ra, 12(sp)                  
    jal     ra, load_byte
    lw      ra, 12(sp)
    mv      s2, a0
    mv      a0, s0                              ; Загрузка длины pstr1 в a0
    sw      ra, 12(sp)
    jal     ra, load_byte
    lw      ra, 12(sp)
    mv      t0, s0                              ; Сохранение указателя на начало pstr1 (s0) в t0 (временное)
    add     s0, s0, a0                          ; Сдвиг указателя pstr1 к элементу после конца
    addi    s0, s0, 1                           ; Добавление длины + 1
    add     a0, a0, s2                          ; Сохранение общей длины pstr1 (a0) и pstr2 (s2)
    mv      a1, t0                              ; В начало pstr1 (t0)
    sw      ra, 12(sp)
    jal     ra, store_byte
    lw      ra, 12(sp)
    addi    s1, s1, 1                           ; Пропуск первого байта с размером в pstr2
    ; s0 -> указатель на pstr1
    ; s1 -> указатель на pstr2
    ; s2 -> количество оставшихся символов в pstr2
concate_cycle:
    beqz    s2, ret_concate_pstrs               ; Если в pstr2 не осталось символов, возврат
    addi    s2, s2, -1                          ; Уменьшение количества оставшихся символов
    lw      a0, 0(s1)                           ; Загрузка текущего символа из pstr2 и сохранение в текущую позицию pstr1
    mv      a1, s0
    sw      ra, 12(sp)
    jal     ra, store_byte
    lw      ra, 12(sp)
    addi    s0, s0, 1                           ; Увеличение указателей
    addi    s1, s1, 1
    j       concate_cycle                       ; Продолжение цикла
ret_concate_pstrs:
    mv      a0, s0                              ; Запись указателя на символ после конца pstr1 (s0) в a0
    lw      s0, 0(sp)                           ; Восстановление регистров
    lw      s1, 4(sp)
    lw      s2, 8(sp)
    addi    sp, sp, 16
    jr      ra                                  ; Возврат
 
; Загрузка нижнего байта из заданного адреса
; Аргументы
;   a0 -> адрес
; Возврат
;   a0 -> загруженный байт
load_byte:
    lw      a0, 0(a0)                           ; Загрузка из памяти
    addi    t0, zero, 0xff                      ; Инициализация маски 0x000000ff
    and     a0, a0, t0                          ; Применение маски
    jr      ra                                  ; Возврат
 
; Сохранение нижнего байта по заданному адресу
; Остальные байты слова не изменяются
; Аргументы
;   a0 -> данные для записи
;   a1 -> адрес
store_byte:
    lw      t0, 0(a1)                           ; Загрузка слова по адресу
    addi    t1, zero, 8                         ; Создание маски 0xffffff00
    addi    t2, zero, -1
    sll     t2, t2, t1
    addi    t3, zero, 0xff                      ; Создание маски 0x000000ff
    and     t0, t0, t2                          ; Применение первой маски для очистки нижнего байта в t0
    and     a0, a0, t3                          ; Применение второй маски для очистки всего, кроме нижнего байта в a0
    or      t0, t0, a0                          ; Обновление байта
    sw      t0, 0(a1)                           ; Сохранение слова
    jr      ra                                  ; Возврат

.data
buf_data:             .byte  '________________________________'   ; Буфер длиной 32 байта, инициализированный '_'
buf_size:             .word  0x20                                 ; Размер буфера = 32
in_stop_char:         .word  '\n'                                 ; Символ окончания ввода (перевод строки)
ascii_offset:         .word  0x20                                 ; Разница между строчной и прописной буквой в ASCII
ascii_low_start:      .word  0x60                                 ; Один меньше, чем 'a' (97), для проверки диапазона
ascii_low_end:        .word  0x7a                                 ; 'z' (122)
ascii_up_start:       .word  0x40                                 ; Один меньше, чем 'A' (65), для проверки диапазона
ascii_up_end:         .word  0x5a                                 ; 'Z' (90)
word_separator:       .word  ' '                                  ; Пробел — разделитель слов
overflow_error:       .word  0xcccccccc                           ; Значение ошибки при переполнении буфера
char_mask:            .word  0x7f                                 ; Маска для обрезки до 7-битного ASCII
input_addr:           .word  0x80                                 ; Адрес ввода (MMIO)
output_addr:          .word  0x84                                 ; Адрес вывода (MMIO)
 
.text
.org 0x100
 
_start:
    ; Инициализация указателя стека (sp = 0x1000 - 4)
    lui     sp, 1
    addi    sp, sp, -4
 
    ; Загрузить адрес вывода в s0
    lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
    lw      s0, 0(t0)
 
    ; Загрузить адрес ввода в a0
    lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
    lw      a0, 0(t0)
 
    ; Загрузить ascii_offset в s1
    lui     t1, %hi(ascii_offset)
    addi    t1, t1, %lo(ascii_offset)
    lw      s1, 0(t1)
 
    ; Загрузить границы для строчных букв
    lui     t1, %hi(ascii_low_start)
    addi    t1, t1, %lo(ascii_low_start)
    lw      s2, 0(t1)
 
    lui     t1, %hi(ascii_low_end)
    addi    t1, t1, %lo(ascii_low_end)
    lw      s3, 0(t1)
 
    ; Загрузить границы для прописных букв
    lui     t1, %hi(ascii_up_start)
    addi    t1, t1, %lo(ascii_up_start)
    lw      s4, 0(t1)
 
    lui     t1, %hi(ascii_up_end)
    addi    t1, t1, %lo(ascii_up_end)
    lw      s5, 0(t1)
 
    ; Загрузить символ окончания ввода
    lui     t1, %hi(in_stop_char)
    addi    t1, t1, %lo(in_stop_char)
    lw      s6, 0(t1)
 
    ; Загрузить пробел — разделитель слов
    lui     t1, %hi(word_separator)
    addi    t1, t1, %lo(word_separator)
    lw      s7, 0(t1)
 
    ; Загрузить маску символов
    lui     t1, %hi(char_mask)
    addi    t1, t1, %lo(char_mask)
    lw      s8, 0(t1)
 
    ; Установить a1 = &buf_data
    lui     t1, %hi(buf_data)
    addi    a1, t1, %lo(buf_data)
 
    ; Загрузить размер буфера в a2
    lui     t1, %hi(buf_size)
    addi    t1, t1, %lo(buf_size)
    lw      a2, 0(t1)
 
    addi    a3, zero, 1
 
    jal     ra, capitalize_recursive
 
    lui     t2, %hi(buf_data)
    addi    t2, t2, %lo(buf_data)
 
print_loop:
    lw      t3, 0(t2)
    and     t3, t3, s8                   
    beqz    t3, done_print               ; Если 0 — конец строки
    sw      t3, 0(s0)                    ; Выводим символ
    addi    t2, t2, 1
    j       print_loop
 
done_print:
    halt
 
 
capitalize_recursive:
    addi    sp, sp, -20                  ; Выделить стек
    sw      ra, 16(sp)
    sw      a1, 12(sp)
    sw      a2,  8(sp)
    sw      a3,  4(sp)
    sw      a0,  0(sp)
 
    ; Проверка на переполнение буфера
    beq     a2, zero, handle_overflow
 
    ; Считать байт из ввода
    lw      t0, 0(a0)
    and     t0, t0, s8
 
    ; Если конец ввода — завершить
    beq     t0, s6, end_of_buffer
 
    ; Если символ — пробел
    beq     t0, s7, space_and_recurse
 
    ; Если это начало слова и буква — строчная
    beq     a3, zero, inside_word
    ble     t0, s2, clear_flag
    bgt     t0, s3, clear_flag
    sub     t0, t0, s1                   ; Преобразовать в прописную
 
clear_flag:
    addi    a3, zero, 0                  ; Сбросить флаг начала слова
    j       write_and_recurse
 
inside_word:
    ble     t0, s4, write_and_recurse
    bgt     t0, s5, write_and_recurse
    add     t0, t0, s1                   ; Преобразовать в строчную
 
write_and_recurse:
    sb      t0, 0(a1)                    ; Записать символ в буфер
    addi    a1, a1, 1
    addi    a2, a2, -1
    jal     ra, capitalize_recursive
 
    ; Восстановление из стека
    lw      ra, 16(sp)
    lw      a1, 12(sp)
    lw      a2,  8(sp)
    lw      a3,  4(sp)
    lw      a0,  0(sp)
    addi    sp, sp, 20
    jr      ra
 
space_and_recurse:
    sb      t0, 0(a1)                    ; Записать пробел
    addi    a1, a1, 1
    addi    a2, a2, -1
    addi    a3, zero, 1                  ; Следующий символ — начало слова
    jal     ra, capitalize_recursive
    lw      ra, 16(sp)
    lw      a1, 12(sp)
    lw      a2,  8(sp)
    lw      a3,  4(sp)
    lw      a0,  0(sp)
    addi    sp, sp, 20
    jr      ra
 
end_of_buffer:
    sb      zero, 0(a1)                  ; Поставить нуль-терминатор
    lw      ra, 16(sp)
    lw      a1, 12(sp)
    lw      a2,  8(sp)
    lw      a3,  4(sp)
    lw      a0,  0(sp)
    addi    sp, sp, 20
    jr      ra
 
handle_overflow:
    lui     t1, %hi(overflow_error)
    addi    t1, t1, %lo(overflow_error)
    lw      t2, 0(t1)
    sw      t2, 0(s0)
    halt

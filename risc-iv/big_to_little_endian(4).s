.data
    input_ptr:      .word 0x80    ; Указатель на входные данные
    output_ptr:     .word 0x84    ; Указатель на выходные данные
    stack_base:     .word 0x1000  ; Базовый адрес стека
    num_bytes:      .word 4       ; Количество байт для обработки
.text
.org 0x88
_start:
    ; Инициализация стека
    lui     sp, %hi(stack_base)
    addi    sp, sp, %lo(stack_base)
    lw      sp, 0(sp)
 
    addi    sp, sp, -4
    jal     ra, solve
 
    halt
 
solve:
    ; Сохраняем адрес возврата
    sw      ra, 0(sp)
 
    addi    sp, sp, -4
    jal     ra, get_input
    jal     ra, reverse_bytes
    jal     ra, save_result
    addi    sp, sp, 4
 
    lw      ra, 0(sp)
    jr      ra
 
get_input:
    ; Загружаем входное значение
    sw      ra, 0(sp)
    lui     t0, %hi(input_ptr)
    addi    t0, t0, %lo(input_ptr)
    lw      t0, 0(t0)
    lw      t1, 0(t0)
    lw      ra, 0(sp)
    jr      ra
 
reverse_bytes:
    ; Функция проверки и перестановки байт
    sw      ra, 0(sp)
 
    ; Загружаем количество байт
    lui     t0, %hi(num_bytes)
    addi    t0, t0, %lo(num_bytes)
    lw      t0, 0(t0)
 
    ; Инициализация регистров
    addi    a4, zero, 0      ; Результат
    addi    t5, zero, 255    ; Маска байта
    addi    t6, zero, 0      ; Счетчик сдвига
 
    ; Вычисляем начальный сдвиг
    addi    t3, t0, -1
    addi    t4, zero, 3
    sll     t3, t3, t4
 
reverse_loop:
    ; Проверяем завершение цикла
    beqz    t0, reverse_done
 
    ; Уменьшаем stack pointer и вызываем swap_bytes
    addi    sp, sp, -4
    jal     ra, swap_bytes
    addi    sp, sp, 4
 
    ; Переходим к следующему байту
    addi    t6, t6, 8
    addi    t3, t3, -8
    addi    t0, t0, -1
    j       reverse_loop
 
reverse_done:
    lw      ra, 0(sp)
    jr      ra
 
swap_bytes:
    ; Функция перестановки одного байта
    sw      ra, 0(sp)
 
    ; Извлекаем текущий байт
    srl     t2, t1, t6
    and     t2, t2, t5
 
    ; Сдвигаем байт на нужную позицию
    sll     t2, t2, t3
    or      a4, a4, t2
 
    lw      ra, 0(sp)
    jr      ra
 
save_result:
    ; Сохраняем результат
    sw      ra, 0(sp)
    lui     t0, %hi(output_ptr)
    addi    t0, t0, %lo(output_ptr)
    lw      t0, 0(t0)
    sw      a4, 0(t0)
    lw      ra, 0(sp)
    jr      ra

.data
input_addr:      .word  0x80
output_addr:     .word  0x84
 
.text
.org 0x88  ; Начинаем код с адреса 0x88
 
f_init_stack:
    addi    sp, zero, 0x100  ; Инициализация стека
    jr      ra
 
f_count_leading_zeros:
    ; args: a0 - input value
    ; returns: a0 - count of leading zeros
    addi    sp, sp, -4
    sw      ra, 0(sp)
 
    beqz    a0, return_32      ; если 0, вернуть 32
 
    addi    t2, zero, 0       ; счетчик = 0
    addi    t3, zero, 31      ; i = 31
 
count_loop:
    addi    t6, zero, 0
    bgt     t6, t3, count_done ; если i < 0, выход
 
    add     t4, a0, zero      ; копия входного значения
    srl     t4, t4, t3        ; сдвигаем на i позиций
    addi    t5, zero, 1       ; t5 = 1
    and     t4, t4, t5        ; проверяем младший бит (заменили andi на and)
    bnez    t4, count_done    ; если бит установлен, выход
 
    addi    t2, t2, 1         ; увеличиваем счетчик
    addi    t3, t3, -1        ; уменьшаем позицию
    j       count_loop
 
return_32:
    addi    t2, zero, 32      ; возвращаем 32 для нуля
    j       count_done
 
count_done:
    mv      a0, t2            ; сохраняем результат в a0
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra
 
f_print_result:
    ; args: a0 - value to print
    lui     t0, %hi(output_addr)
    addi    t0, t0, %lo(output_addr)
    lw      t0, 0(t0)
    sw      a0, 0(t0)
    jr      ra
 
f_do_task:
    addi    sp, sp, -4
    sw      ra, 0(sp)
 
    ; Загрузка входного значения
    lui     t0, %hi(input_addr)
    addi    t0, t0, %lo(input_addr)
    lw      t0, 0(t0)
    lw      a0, 0(t0)
 
    jal     ra, f_count_leading_zeros
    jal     ra, f_print_result
 
    lw      ra, 0(sp)
    addi    sp, sp, 4
    jr      ra
 
_start:
    jal     ra, f_init_stack
    jal     ra, f_do_task
    halt

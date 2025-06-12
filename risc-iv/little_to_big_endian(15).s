.data
    .org 0x90
input_addr:      .word  0x80
output_addr:     .word  0x84
overflow_flag:   .word  0xCCCC
 
.text
 
_start:
    lui sp, 0x1
    addi sp, sp, -32   ;взяли место на стеке и 32 бита туда записали
    sw   ra,  0(sp)    ;сохранили адрес куда возвращать будем
    sw   t0,  4(sp)    ;сохранили временные регистры
    sw   t1,  8(sp)
    sw   t2, 12(sp)
    sw   t3, 16(sp)
    sw   t4, 20(sp)
    sw   t5, 24(sp)
 
    jal  ra, setup_constants     ;вызываем процедуры подряд (сдвиги и маски)
    jal  ra, load_data         ;грузим дату
    jal  ra, main_program       ;собсна перестановка
    jal  ra, overflow_check      ;проверка оверфлоу
    jal  ra, write_result        ;сохраняем
 
    lw   ra,  0(sp)     ;восстанавливаем сохранённые регистры и выходим
    lw   t0,  4(sp)
    lw   t1,  8(sp)
    lw   t2, 12(sp)
    lw   t3, 16(sp)
    lw   t4, 20(sp)
    lw   t5, 24(sp)
    addi sp, sp, 32
 
    j end 
 
setup_constants:
    addi a1, zero, 24     ;константы сдвига
    addi a2, zero, 16
    addi a3, zero, 8
    addi a4, zero, 255    ;маска
    jr ra
 
load_data:
    lui  t0, %hi(input_addr)    ;грузим верх грузим низ сейвим
    addi t0, t0, %lo(input_addr)
    lw   t0, 0(t0)
 
    lui  t1, %hi(output_addr)    ;то же для аутпута
    addi t1, t1, %lo(output_addr)
    lw   t1, 0(t1)      ;по этому адресу результат пишем
 
    lw   t2, 0(t0)      ;само число  
    lui   t3, 0        ;обнуляем результат 
    jr ra
 
main_program:
    srl  tp, t2, a1      ;всё то же что было раньше
    and  tp, tp, a4
    or   t3, t3, tp
 
    srl  tp, t2, a2
    and  tp, tp, a4
    sll  tp, tp, a3
    or   t3, t3, tp
 
    srl  tp, t2, a3
    and  tp, tp, a4
    sll  tp, tp, a2
    or   t3, t3, tp
 
    and  tp, t2, a4
    sll  tp, tp, a1
    or   t3, t3, tp
 
    jr ra
 
overflow_check:      ;то же что раньше
    mv   t4, t3
    lui   t5, 0
 
    srl  tp, t4, a1
    and  tp, tp, a4
    or   t5, t5, tp
 
    srl  tp, t4, a2
    and  tp, tp, a4
    sll  tp, tp, a3
    or   t5, t5, tp
 
    srl  tp, t4, a3
    and  tp, tp, a4
    sll  tp, tp, a2
    or   t5, t5, tp
 
    and  tp, t4, a4
    sll  tp, tp, a1
    or   t5, t5, tp
 
    bne  t5, t2, handle_overflow 
    jr ra
 
handle_overflow:      ;грузим ссссс если переполнение
    lui   t3, 0xCCCC
    sw   t3, 0(t1)
    j abort 
 
write_result:      ;сейим в т3
    sw   t3, 0(t1)
    jr ra
 
abort:        ;восстанавливаем регистры если конец по переполнению
    lw   ra,  0(sp)
    lw   t0,  4(sp)
    lw   t1,  8(sp)
    lw   t2, 12(sp)
    lw   t3, 16(sp)
    lw   t4, 20(sp)
    lw   t5, 24(sp)
    addi sp, sp, 32
    halt
 
end:
    halt

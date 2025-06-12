 
    .data
.org             0x100
 
input_addr:      .word  0x80                ; Input address where the number 'n' is stored
output_addr:     .word  0x84                ; Output address where the result should be stored
stack_start:     .word  0x900               ; Address where the stack should be start
 
    .text
    .org     0x200
is_palindrome:
    addi     sp, sp, -4
    sw       ra, 0(sp)
 
    add      a1, zero, zero                  ; Левый индекс (младший бит)
    addi     a2, zero, 31                    ; Правый индекс (старший бит)
    jal      ra, compare_bits                ; Вызываем рекурсивную проверку
 
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra
 
 
 
compare_bits:
    bgt      a1, a2, return_true
    beq      a1, a2, return_true             ; if a1 >= a2 then goto return_true
 
    addi     t2, zero, 1                     ; маска для изоляции 0x1
 
    addi     sp, sp, -4
    sw       ra, 0(sp)
 
 
    ; Извлекаем бит слева
    srl      t0, a0, a1                      ; Сдвигаем к младшему биту
    and      t0, t0, t2                      ; Изолируем бит
 
    ; Извлекаем бит справа
    srl      t1, a0, a2                      ; Сдвигаем к младшему биту
    and      t1, t1, t2                      ; Изолируем бит
 
    bne      t0, t1, return_false            ; Биты не совпадают
 
    ; Подготавливаем новые индексы
    addi     a1, a1, 1                       ; left++
    addi     a2, a2, -1                      ; right--
    jal      ra, compare_bits                ; Рекурсивный вызов
 
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra
 
 
 
return_false:
    add      a0, zero, zero                  ; Возвращаем 0
    lw       ra, 0(sp)
    addi     sp, sp, 4
    jr       ra
 
return_true:
    addi     a0, zero, 1                     ; Возвращаем 1
    jr       ra
 
 
_start:
    lui      t0, %hi(stack_start)
    addi     t0, t0, %lo(stack_start)
    lw       sp, 0(t0)
 
 
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       t0, 0(t0)
    lw       a0, 0(t0)
 
    jal      ra, is_palindrome
 
 
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
    lw       t0, 0(t0)
    sw       a0, 0(t0)
 
    halt

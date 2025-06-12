.data
input_addr:   .word 0x80    ; ввод
output_addr:  .word 0x84    ; вывод
 
.text
.org 0x100
 
_start:
    ; ввод/вывод
    lui     a1, %hi(input_addr)
    addi    a1, a1, %lo(input_addr)
    lw      a2, 0(a1)                ; a2 <- input_addr
    lw      a3, 4(a1)                ; a3 <- output_addr
 
    lw      a0, 0(a2)                ; a0 = n
    addi    a4, zero, 0              ; a4 = 0 (тут будет сумма)
 
    bgt     a0, zero, sum_loop       ; if n >= 0 GOTO sum_loop
    sub     a0, zero, a0             ; делаем положительным
 
sum_loop:
    addi    a1, zero, 10             ; a1 = 10 (на это будем делить)    
    rem     a5, a0, a1               ; a5 = a0 % 10 (последняя цифра)
    add     a4, a4, a5               ; a4 += a5
    div     a0, a0, a1               ; a0 = a0 // 10
 
    beqz    a0, end                  ; if a0 == 0 GOTO 
    j       sum_loop                 ; цикл
 
end:
    sw      a4, 0(a3)                ; выводим ответ   
    halt                             ; стоп машина

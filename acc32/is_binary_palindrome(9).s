    .data
input_addr:      .word  0x80               ; input
output_addr:     .word  0x84               ; output
n:               .word  0x00               ; число которое проверяем
copy_n:          .word  0x00               ; сюда скопируем n
reversed_n:      .word  0x00               ; здесь будет развернутое n
i:               .word  0x00               ; счетчик для цикла
one:             .word  0x01               ; единичка (пригодится)
 
    .text
    .org 0x100
_start:
    load_ind     input_addr                  ; acc = *input_addr
    store        n                           ; n = acc
    store        copy_n                      ; copy_n = acc
 
revert_n:
    load_imm     32                          ; машинное слово у нас 32 бита
    store        i                           ; i = 32
 
loop:
    load         i                           ; acc = i
    beqz         end_loop                    ; i == 0 ? -> end_loop (дошли до нуля? конец!)
    sub          one                         ; acc = i - 1
    store        i                           ; save i
 
    load         reversed_n                  ; acc = reversed_n
    shiftl       one                         ; reversed_n << на один разряд
    store        reversed_n                  ; reversed_n = acc
 
    load         copy_n                      ; acc = copy_n
    and          one                         ; acc = copy_n & 1 (last digit of copy_n)
    add          reversed_n                  ; acc = reversed_n + (copy_n mod 2)
    store        reversed_n                  ; reversed_n = acc
 
    load         copy_n                      ; acc = copy_n
    shiftr       one                         ; copy_n >> на один разряд
    store        copy_n                      ; copy_n = acc
    jmp          loop                        ; порочный круг
 
end_loop:
    load         n                           ; acc = n
    sub          reversed_n                  ; acc = n - reversed_n
    bnez         is_not_palindrome           ; n != reversed_n ? -> n не палиндромчик
 
is_palindrome:
    load_imm     1                           ; ответ: true
    store_ind    output_addr                 ; stdout
    halt
 
is_not_palindrome:
    load_imm     0                           ; ответ: false
    store_ind    output_addr                 ; stdout
    halt

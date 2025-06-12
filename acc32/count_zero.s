    .data
input_addr:      .word  0x80               ; Адрес для ввода
output_addr:     .word  0x84               ; Адрес для вывода
n:               .word  0x20               ; Наша n для 32 итераций
result:          .word  0x00               ; Место для результата
const_1:         .word  0x01               ; Константа единицы
value:           .word  0x00
 
    .text
 
_start:
    load_ind     input_addr
    store        value
 
for_loop:
    load         n
    beqz         end
 
    load         n
    sub          const_1                     ; уменьшаем счётчик итераций
    store        n
 
    load         value
    and          const_1
    beqz         count_zero                  ; проверяем на ноль через И с единицей
 
    jmp          shift
 
count_zero:
    load         result
    add          const_1                     ; увеличиваем счётчик нулей
    store        result
 
shift:
 ; Делаем сдвиг
    load         value
    shiftr       const_1
    bvs          handle_overflow             ; Проверяем на переполнение
    store        value
    jmp          for_loop
 
end:
    load         result
    store_ind    output_addr                 ; выводим результат
    halt
 
 
    ;exceptions
handle_overflow:
    load_imm     0xCCCC_CCCC                 ; ловим переполнение и выводим необходимые символы
    store_ind    output_addr
    halt

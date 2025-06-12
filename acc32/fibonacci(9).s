    .data
 
read_addr:       .word  0x80               ; Адрес, откуда читается значение
write_addr:      .word  0x84               ; Адрес, куда записывается результат
counter:         .word  0x00               ; Счётчик итераций
unit:            .word  0x01               ; Единичная константа
curr_val:        .word  0x00               ; Текущее значение
next_val:        .word  0x01               ; Следующее значение
swap_temp:       .word  0x00               ; Переменная для обмена значениями
 
    .text
 
_start:
    load_ind     read_addr                 ; Считываем значение
    store        counter
 
    ble          domain_error              ; Отрицательное — ошибка
 
main_loop:
    load         counter
    sub          unit
    ble          done
    store        counter
 
    load         next_val
    store        swap_temp
    add          curr_val
    bvs          handle_overflow
    store        next_val
    load         swap_temp
    store        curr_val
 
    jmp          main_loop
 
done:
    load         curr_val
    store_ind    write_addr
    halt
 
handle_overflow:
    load_imm     0xCCCCCCCC
    store_ind    write_addr
    halt
 
domain_error:
    load_imm     -1
    store_ind    write_addr
    halt

.data
 
input_addr:     .word  0x80       ; адрес входного числа
output_addr:    .word  0x84       ; адрес вывода результата
orig_num:       .word  0x00       ; исходное число
work_num:       .word  0x00       ; временный регистр для извлечения битов
rev_num:        .word  0x00       ; накопитель для «развёрнутого» числа
bit_counter:    .word  0x00       ; счётчик битов (0–32)
ONE:            .word  0x01       ; константа 1
 
.text
_start:
    load_ind     input_addr        ; acc = [input_addr]
    store        orig_num          ; orig_num = acc
    store        work_num          ; work_num = acc
 
    ; Инициализируем счётчик битов = 32
    load_imm     32
    store        bit_counter
 
reverse_loop:
    load         bit_counter       ; acc = bit_counter
    beqz         end_reverse       ; если бит_counter == 0, выходим
    sub          ONE               ; bit_counter--
    store        bit_counter
 
    ; rev_num <<= 1
    load         rev_num
    shiftl       ONE
    store        rev_num
 
    ; извлекаем младший бит из work_num и добавляем к rev_num
    load         work_num
    and          ONE               ; acc = work_num & 1
    add          rev_num           ; acc = rev_num + (work_num & 1)
    store        rev_num
 
    ; work_num >>= 1
    load         work_num
    shiftr       ONE
    store        work_num
    jmp          reverse_loop
 
end_reverse:
    ; сравниваем orig_num и rev_num
    load         orig_num
 
    xor          rev_num
    beqz         is_palindrome    ; если orig_num - rev_num == 0
 
    load_imm     0
    jmp end
 
is_palindrome:
    load_imm     1
end:
    store_ind    output_addr
    halt

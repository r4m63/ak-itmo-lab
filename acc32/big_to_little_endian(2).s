    .data
input_addr:      .word  0x80        ;адрес ввода
output_addr:     .word  0x84		;адрес вывода
 
byte0:           .word  0xff000000	;маска старший байт
byte1:           .word  0x00ff0000	;маска второй байт
byte2:           .word  0x0000ff00	;маска третьий байт
byte3:           .word  0x000000ff	;маска младший байт
 
shift_8:         .word  8		    ;сдвиг на 1 байт
shift_24:        .word  24		    ;сдвиг на 3 байта
 
n:               .word  0x0		    ;ввод значение
result:          .word  0x0		    ;результат
 
    .text
_start:
    load_ind     input_addr		    ;загрузка входного значения
    store        n			        ;сохранение в переменную
 
big_to_little_endian:
    load         n			        ;загрузка входного значения
    shiftl       shift_24		    ;сдвиг младшего байта
    and          byte0			    ;извлекаем новый старший байт
    store        result			    ;промежуточный результат
 
    load         n			        
    shiftl       shift_8		    ;сдвиг второго байта
    and          byte1			    ;извлечение
    or           result			    ;объединение с результатом
    store        result			    
 
    load         n			        
    shiftr       shift_8		    ;сдвиг третьего байта
    and          byte2			    ;извлечение
    or           result			    ;объединение с результатом
    store        result			
 
    load         n			
    shiftr       shift_24		    ;сдвиг четвертого байта
    and          byte3			    ;извлечение
    or           result			    ;финальное объединение
 
end:
    store_ind    output_addr		;сохраняем результат по адресу
    halt				            ;завершение

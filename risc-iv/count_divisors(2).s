.data
 
input_addr:        .word       0x80
output_addr:       .word       0x84
 
.text
.org 0x88
 
stack_init:				                ; инициализация стека
    addi sp, zero, 0x500            
    jr ra                          
 
 
_start:
    jal ra, stack_init
 
    lui t0, %hi(input_addr)        
    addi t0, t0, %lo(input_addr)   
    lw t0, 0(t0)                    	; получили адрес 0х80
    lw t1, 0(t0)                	    ; загрузили входное число 
 
    addi t2, zero, 0                	; счетчик делителей
    addi a0, zero, 1                	; текущий делитель
    addi a1, zero, 1                	; шаг увеличения делителя
    addi a3, t1, 1                  	; верхняя граница цикла
    addi t5, zero, -1               	; константа для проверки
 
    jal ra, main        		
    j exit
 
 
main:
    addi sp, sp, -4                
    sw ra, 0(sp)			            ; сохранили адрес возврата                  
    sub t4, t1, a1			
    ble t4, t5, error			        ; переход, если t1-a1<=-1
    jal ra, count_divisors           
    j end
 
 
count_divisors:
    addi sp, sp, -4
    sw ra, 0(sp)   			            ; сохранили адрес возврата  
    beq a0, a3, end     		        ; выход, если делитель достиг верхней границы            
    rem t3, t1, a0                  	; инициализируем остаток от деления
    bnez t3, not_divisor            	; если остаток не равен 0, то не делитель
    addi t2, t2, 1                  	; увеличили счетчик делителей
 
 
not_divisor:
    add a0, a0, a1                  	; текущий делитель=делитель+1
    j count_divisors
 
 
error:   				                ; обработка ошибки
    addi t2, t2, -1
    j exit
 
 
end:					
    lw ra, 0(sp)                     	; восстановка адреса возврата
    addi sp, sp, 4                  	; освобождение стека
    jr ra                           	; возврат из процедуры
 
 
exit:
    lui t0, %hi(output_addr)       
    addi t0, t0, %lo(output_addr)   
    lw t0, 0(t0)                    	; получили 0x84
    sw t2, 0(t0)                    	; загрузили результат
    halt

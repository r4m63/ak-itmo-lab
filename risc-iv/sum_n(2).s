    .data
 
input_addr:      .word  0x80               ; input address
output_addr:     .word  0x84               ; output address
neg_one:         .word 0xFFFFFFFF    ;  -1  (ошибка n ≤ 0)
cc_word:         .word 0xCCCCCCCC    ; 0xCC… (переполнение)
const_1:         .word  0x01
 
.org             0x90
    .text
 
_start:
    ; make t1 a constant 1
    lui      t1, %hi(const_1)
    addi     t1, t1, %lo(const_1)         ; t1 = 0x1
    lw       t1, 0(t1)
 
    ; actual start
    jal      ra, read_number
    ; now a0 = number
 
    jal      ra, calculate_sum_n
 
    jal      ra, print_res
 
 
    halt
 
; ===============
 
calculate_sum_n:
    ble      a0, t3, err_neg                ; если n <= 0 -> ошибка
 
    add      a1, a0, t1                      ; a1 = n + 1 (addi работает только с 12 битами. Чтобы не терять ОДЗ, использую add)
    and      a2, a0, t1                      ; a2 = n & 1 (чётность)
 
 
 
    bnez     a2, odd_case
    ; мы сначала делим на 2, потом умножаем – так можно увеличить ОДЗ.
    ; поэтому выбираем, что поделить – n или n+1. Одно из них обязательно чётное
 
    ; ------ n чётное: (n/2) * (n+1)
    srl      a0, a0, t1                      ; a0 = n / 2 (a0 = a0 >> t1)
    mul      a0, a0, a1                      ; a0 = (n/2) * (n+1)
    j        chk_overflow
 
odd_case:
    srl      a1, a1, t1                      ; a0 = (n+1)/2 (a1 = a1 >> t1)
    mul      a0, a0, a1                      ; a0 = n * ((n+1)/2)
 
chk_overflow:
    bgt      a0, t3, return_from_sum_n       ; если res > 0 – overflow нет
 
    lui      a0, %hi(cc_word)
    addi     a0, a0, %lo(cc_word)            ; a0 = -1 (res = -1)
    lw       a0, 0(a0)
return_from_sum_n:
    jr       ra
 
 
; print_res:
;     lui      t0, %hi(output_addr)
;     addi     t0, t0, %lo(output_addr)
 
;     lw       t0, 0(t0)
 
;     sw       a0, 0(t0)
 
;     halt
 
err_neg:
    lui      a0, %hi(neg_one)
    addi     a0, a0, %lo(neg_one)         ; a0 = -1 (res = -1)
    lw       a0, 0(a0)
 
    ; j        print_res
    jr       ra
 
 
; ============================
read_number:
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)         ; t0 = 0x0
 
    lw       t0, 0(t0)                       ; t0 = 0x80
 
    lw       a0, 0(t0)                       ; a0 = MEM[t0]
 
    jr       ra
 
 
print_res:
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)        ; t0 = 0x04;
 
    lw       t0, 0(t0)                       ; t0 = 0x84
 
    sw       a0, 0(t0)                       ; *output_addr_const = a0;
 
    jr       ra

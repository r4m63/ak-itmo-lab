    .data
input_addr:   .word 0x80    ; адрес ввода (numio[0x80])
output_addr:  .word 0x84    ; адрес вывода (numio[0x84])
number:       .word   0     ; сюда запишем n
del:          .word   3     ; первый нечётный делитель
two:          .word   2     ; константа 2
one:          .word   1     ; константа 1
 
    ; pad до адреса 0x88 (136 байт), чтобы .text стартовал после I/O (0x80–0x87)
pad0:  .word 0
pad1:  .word 0
pad2:  .word 0
pad3:  .word 0
pad4:  .word 0
pad5:  .word 0
pad6:  .word 0
pad7:  .word 0
pad8:  .word 0
pad9:  .word 0
pad10: .word 0
pad11: .word 0
pad12: .word 0
pad13: .word 0
pad14: .word 0
pad15: .word 0
pad16: .word 0
pad17: .word 0
pad18: .word 0
pad19: .word 0
pad20: .word 0
pad21: .word 0
pad22: .word 0
pad23: .word 0
pad24: .word 0
pad25: .word 0
pad26: .word 0
pad27: .word 0
 
    .text
_start:
    ; --- 1) читаем вход n ---
    load_ind    input_addr       ; ACC ← mem[mem[input_addr]]
    store_addr  number           ; mem[number] = n
 
    ; --- 2) n ≤ 0 → –1 ---
    load_addr   number           ; ACC ← n
    beqz        end_negative     ; если n == 0
    ble         end_negative     ; если n <  0
 
    ; --- 3) n == 1 → 0 ---
    load_addr   number           ; ACC ← n
    sub         one              ; ACC ← n – 1
    beqz        end_composite    ; если n == 1
 
    ; --- 4) n == 2 → 1 ---
    load_addr   number           ; ACC ← n
    sub         two              ; ACC ← n – 2
    beqz        end_prime        ; если n == 2
 
    ; --- 5) чётные (>2) → 0 ---
    load_addr   number           ; ACC ← n
    rem         two              ; ACC ← n mod 2
    beqz        end_composite    ; если чётное
 
    ; --- 6) пробное деление нечётными d = 3,5,7… ---
loop:
    load_addr   del              ; ACC ← d
    mul         del              ; ACC ← d * d
    sub         number           ; ACC ← d² – n
    bgt         end_prime        ; если d² > n → простое
 
    load_addr   number           ; ACC ← n
    rem         del              ; ACC ← n mod d
    beqz        end_composite    ; если найден делитель → составное
 
    load_addr   del              ; ACC ← d
    add         two              ; ACC ← d + 2
    store_addr  del              ; d = d + 2
    jmp         loop
 
end_negative:
    load_imm    -1               ; ACC ← –1
    store_ind   output_addr      ; вывод –1
    jmp         end
 
end_composite:
    load_imm    0                ; ACC ← 0
    store_ind   output_addr      ; вывод 0
    jmp         end
 
end_prime:
    load_imm    1                ; ACC ← 1
    store_ind   output_addr      ; вывод 1
 
end:
    halt

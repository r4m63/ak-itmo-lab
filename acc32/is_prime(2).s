    .data
 
input_addr:   .word  0x80
output_addr:  .word  0x84
n:            .word  0x00
const_1:      .word  0x01
i:            .word  0x02
const_1_neg:   .word  -1
 
    .text
 
_start:
    load_ind    input_addr     ; acc ← *input_addr
    bgt         init            ; если acc > 0, идём дальше
    jmp         return_invalid  ; иначе (acc ≤ 0) → –1
 
init:
    store       n               ; n ← acc
    load        n
    sub         const_1         ; acc ← n – 1
    beqz        return_zero     ; если n == 1 → 0
 
    load_imm    2
    store       i
 
loop:
    load        n
    rem         i               ; acc ← n % i
    beqz        return_zero     ; делится без остатка → 0 (составное)
 
    load        n
    div         i
    sub         i
    bgt         continue_loop
    jmp         return_one
 
 
continue_loop:
    ; иначе i++, и повторяем
    load        i
    add         const_1
    store       i
    jmp         loop
 
return_one:
    load_imm    1
    store_ind   output_addr
    halt
 
return_zero:
    load_imm    0
    store_ind   output_addr
    halt
 
return_overflow:
    load_imm    0xCCCCCCCC
    store_ind   output_addr
    halt
 
return_invalid:
    load    const_1_neg
    store_ind   output_addr
    halt

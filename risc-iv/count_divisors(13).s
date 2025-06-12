.data
.org 0x100
 
input_address:      .word 0x80
output_address:     .word 0x84
 
.text
.org 0x200
 
; Counts the divisors of a number N
; Accepts:
; a0: N
; Returns:
; a0: number of divisors of N if N > 1, else a0: -1
 
count_divisors:
 
    mv      t1, zero
    ble     a0, t1, count_divisors_invalid_input                ; if a0 < 1 then invalid input
 
    mv      t0, a0                      ; uint const t0 = n     ; dividend
    add     t1, t0, zero                ; uint t1 = n           ; divisor
    addi    t2, zero, 1                 ; uint const t2 = 1
    mv      a0, zero                    ; a0                    ; result
 
count_divisors_loop:
 
    rem     t3, t0, t1                  ; t3 = remainder of t0 / t1
    bnez    t3, count_divisors_loop_end ; if t3 == 0 then result++
 
    add    a0, a0, t2
 
count_divisors_loop_end:
 
    sub     t1, t1, t2                  ; t1--
    bnez    t1, count_divisors_loop     ; if t1 != 0 then continue
 
    j       count_divisors_end
 
count_divisors_invalid_input:
 
    addi    a0, zero, -1                ; return -1
 
count_divisors_end:
 
    jr      ra
 
 
 
_start:
 
    lui     t0, %hi(input_address)
    addi    t0, t0, %lo(input_address)
    lw      t0, 0(t0)
    lw      a0, 0(t0)                   ; n -> a0
 
    jal     ra, count_divisors          ; call count_divisors
 
    lui     t0, %hi(output_address)
    addi    t0, t0, %lo(output_address)
    lw      t0, 0(t0)
 
    sw      a0, 0(t0)
    halt

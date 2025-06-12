    .text
_start:
    ; Init stack
    lui      sp, %hi(0x1000)                 ; sp = 0x1000
    addi     sp, sp, %lo(0x1000)
 
    lui      a0, %hi(0x80)
    addi     a0, a0, %lo(0x80)               ; load input
 
    lw       a0, 0(a0)                       ; a0 = M[0x80]
 
    jal      ra, reverse_bits                ; call reverse_bits
 
    lui      a1, %hi(0x84)
    addi     a1, a1, %lo(0x84)               ; store result
    sw       a0, 0(a1)                       ; M[0x84] = a0
    halt
 
; bit reverse procedure
reverse_bits:
    addi     sp, sp, -4                      ; push stack
    sw       ra, 0(sp)                       ; save ra before next procedure
 
    ; Init registers
    addi     t1, zero, 1                     ; t1: const = 1
    addi     t3, zero, 0                     ; t3: result = 0
    addi     t4, zero, 32                    ; t4: counter = 32
 
reverse_loop:
    jal      ra, process_bit                 ; process bit
    addi     t4, t4, -1                      ; counter--
    bnez     t4, reverse_loop                ; loop if not done
 
    mv       a0, t3                          ; set return value
    lw       ra, 0(sp)                       ; restore ra
    addi     sp, sp, 4                       ; pop stack
    jr       ra                              ; ret
 
; second procedure - bit process
process_bit:
    sll      t3, t3, t1                      ; result <<= 1
    and      t5, a0, t1                      ; lower bit of n
    or       t3, t3, t5                      ; result |= lower bit of n
    srl      a0, a0, t1                      ; n >>= 1
    jr       ra                              ; ret

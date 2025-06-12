    .data
.org 0x100
 
input_addr:      .word  0x80                ; Input address where the number 'n' is stored
output_addr:     .word  0x84                ; Output address where the result should be stored
stack_addr:      .word  0x900               ; Stack address
error_code:      .word  -858993460          ; Error code
 
    .text
.org 0x200
 
print:
    lui      t0, %hi(output_addr)            
    addi     t0, t0, %lo(output_addr)        
    lw       t0, 0(t0)                      ; t0 = output_addr;
    sw       t2, 0(t0)                      ; *output_addr_const = acc;
    halt
 
error:
    addi     t2, zero, -1                   ; result = -1
    j print
 
solve:                                  
 
    addi     sp, sp, -4                     ; save return address on stack
    sw       ra, 0(sp)
 
    jal      ra, even_n                     ; if n % 2 == 1: n -= 1
    jal      ra, calc                       ; t2 = n * (n + 2) / 4
 
    lw       ra, 0(sp)                      ; restore return address
    addi     sp, sp, 4
    jr       ra                             ; return
 
even_n:
    addi     t3, zero, 2                    ; if (n % 2 == 0):
    rem      t3, t1, t3                     ;   return
    beqz     t3, even_n_return              ; else:
    addi     t1, t1, -1                     ;   n -= 1
 
even_n_return:
    jr       ra                             ; return
 
calc:
    addi     t2, t1, 2                      ; t2 = t1 + 2
    addi     t3, zero, 2                    ; t3 = 2;
    div      t1, t1, t3                     ; t1 /= 2
    div      t2, t2, t3                     ; t2 /= 2
    mul      t2, t2, t1                     ; t2 = t2 * t1
 
    jr       ra                             ; return
 
 
_start:
    lui      t0, %hi(stack_addr)
    addi     t0, t0, %lo(stack_addr)
    lw       sp, 0(t0)                      ; sp = stack_address
 
    lui      t0, %hi(input_addr)             
    addi     t0, t0, %lo(input_addr)         
    lw       t0, 0(t0)                      ; t0 = input_address; 
    lw       t1, 0(t0)                      ; t1 = n;
 
    ble      t1, zero, error                ; if n <= 0: GOTO error
 
    jal      ra, solve                      ; call solve
 
    bgt      t2, zero, print                ; if result > 0: GOTO print
 
    lui      t2, %hi(error_code)            ; else: result = 0xCC
    addi     t2, t2, %lo(error_code)
    lw       t2, 0(t2)
 
    j print

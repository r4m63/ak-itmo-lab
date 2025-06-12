    .data
 
input_addr:      .word  0x80               ; Input address where the number 'n' is stored
output_addr:     .word  0x84               ; Output address where the result should be stored
error_code:      .word  -858993460               ; Error code
 
    .text
 
_start:
    lui      t0, %hi(input_addr)             ; int * input_addr_const = 0x00;
    addi     t0, t0, %lo(input_addr)         ; // t0 <- 0x00;
 
    lw       t0, 0(t0)                       ; int input_addr = *input_addr_const;
    ; // t0 <- *t0;
 
    lw       t1, 0(t0)                       ; int n = *input_addr;
    ; // t1 <- *t0;
    ble      t1, zero, error
 
sum_begin:
    addi     t3, zero, 2                ; if (n % 2 == 1):
    rem      t3, t1, t3                 ;   GOTO sum_while
    beqz     t3, sum_body               ; else:
    addi     t1, t1, -1                 ;   n -= 1
 
sum_body:
    addi     t2, t1, 2                  ; t2 = t1 + 2
    addi     t3, zero, 2                ; t3 = 2;
    div      t1, t1, t3                 ; t1 /= 2
    div      t2, t2, t3                 ; t2 /= 2
    mul      t2, t2, t1                 ; t2 = t2 * t1
    ; t2 = n * (n + 2) / 4
 
sum_end:
    lui      t0, %hi(output_addr)            ; int * output_addr_const = 0x04;
    addi     t0, t0, %lo(output_addr)        ; // t0 <- 0x04;
 
    lw       t0, 0(t0)                       ; int output_addr = *output_addr_const;
    ; // t0 <- *t0;
 
    bgt      t2, zero, print                 ; if t2 > 0: GOTO print
    lui      t2, %hi(error_code)             ; else: t2 = 0xCC
    addi     t2, t2, %lo(error_code)
    lw       t2, 0(t2)
print:
 
    sw       t2, 0(t0)                       ; *output_addr_const = acc;
    ; // *t0 = t2;
 
    halt
 
error:
    lui      t0, %hi(output_addr)            ; int * output_addr_const = 0x04;
    addi     t0, t0, %lo(output_addr)        ; // t0 <- 0x04;
 
    lw       t0, 0(t0)                       ; int output_addr = *output_addr_const;
    ; // t0 <- *t0;
 
    addi     t2, zero, -1                    ; t2 = -1
    sw       t2, 0(t0)                       ; *output_addr_const = acc;
    ; // *t0 = t2;
 
    halt

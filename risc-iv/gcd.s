    .data
 
input_addr:      .word  0x80                 ; Input address
output_addr:     .word  0x84                 ; Output address where the result should be stored
 
    .text
 
_start:
    lui      t0, %hi(input_addr)             ; int upper 20 bits
    addi     t0, t0, %lo(input_addr)         ; add 12 bits => get all input_addr
    lw       t0, 0(t0)                       ; int input_addr = *input_addr_const t0 <- *t0;
    lw       t1, 0(t0)                       ; int a = *input_addr t1 <- *t0;
 
    lui      t0, %hi(input_addr)             ; int upper 20 bits
    addi     t0, t0, %lo(input_addr)         ; add 12 bits => get all input_addr
    lw       t0, 0(t0)                       ; int input_addr = *input_addr_const t0 <- *t0;
    lw       t2, 0(t0)                       ; int b = *input_addr t2 <- *t0;
 
    jal      s4, gcd_while                   ; calling subroutine for loop
 
gcd_end:
    lui      t0, %hi(output_addr)            ; int * output_addr_const = 0x84;
    addi     t0, t0, %lo(output_addr)        ; t0 <- 0x84;
    lw       t0, 0(t0)                       ; int output_addr = *output_addr_const t0 <- *t0;
    sw       t1, 0(t0)                       ; *output_addr_const = acc *t0 = t2;
    halt
 
gcd_while:
 
    while:
        beqz     t2, end                     ; if (t2 == 0) goto gcd_end
        jal      s3, calculate               ; calling subroutine for calculations
        j        while
 
    end:
        jr       s4
 
calculate:
    mv       t3, t2
    rem      t2, t1, t2
    mv       t1, t3
    jr       s3

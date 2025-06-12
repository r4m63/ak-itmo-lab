    .data
buf:             .byte  '________________________________'
buf_size:        .word  0x20
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
const_newline:   .word  0x0A
overflow_sign:   .word  0xCCCCCCCC
buf_mask:        .word  0x5F5F5F00
 
str_len:         .word 0x0
 
    .text
    .org 0x88
 
_start:
    lui     sp, 0x1                         ; initialize stack pointer with 0x1000
    jal     ra, read_line
 
    bnez    a0, call_output_overflow
    jal     ra, output_buf
    halt
 
call_output_overflow:
    jal     ra, output_overflow
    halt
 
read_line:
prep:
    addi    sp, sp, -24                     ; save caller-saved registers a1-a6
    sw      a1, 0(sp)
    sw      a2, 4(sp)
    sw      a3, 8(sp)
    sw      a4, 12(sp)
    sw      a5, 16(sp)
    sw      a6, 20(sp)
 
    lui     a1, 1                           ; capitalize flag
 
    lui     a2, %hi(buf_mask)               ; load memory:dec[52] address
    addi    a2, a2, %lo(buf_mask)           ; a2 <-- 52 (0x34)
 
                                            ; load value from address in register
    lw      a2, 0(a2)                       ; a2 <-- 0x5F5F5F00
 
    lui     a3, %hi(input_addr)
    addi    a3, a3, %lo(input_addr)
 
    lw      a3, 0(a3)                       ; a3 <-- 0x80
 
    lui     a4, %hi(buf)
    addi    a4, a4, %lo(buf)                ; a4 <-- memory:dec[1] buf address
 
    lui     a5, %hi(const_newline)
    addi    a5, a5, %lo(const_newline)
 
    lw      a5, 0(a5)                       ; a5 <-- \n
 
    lui     a6, %hi(buf_size)
    addi    a6, a6, %lo(buf_size)
 
    lw      a6, 0(a6)                       ; a6 <-- buf_size
 
    addi    sp, sp, -4                      ; save value from register 'ra' on the stack
    sw      ra, 0(sp)
    jal     ra, read_and_capitalize
    lw      ra, 0(sp)                       ; restore value from stack to 'ra'
    addi    sp, sp, 4
 
restore_registers:
    lw      a1, 0(sp)
    lw      a2, 4(sp)                       ; restore caller-saved registers a1-a6
    lw      a3, 8(sp)
    lw      a4, 12(sp)
    lw      a5, 16(sp)
    lw      a6, 20(sp)
    addi    sp, sp, 24
    jr      ra
 
 
read_and_capitalize:
; a2 - mask, a3 - input_addr, a4 - buf_addr, a5 - eol_sym=\n, a6 - buf_size; t0 - readable char, t1 - str_len, t2 - uppercase A to compare
    lw      t0, 0(a3)                      ; read character from input
    beq     t0, a5, success                ; if char == '\n' ==> end
 
    addi    t0, t0, -32
    addi    t2, t2, 64
    addi    t3, t3, 32
    beq     t0, zero, set_capitalize_flag
    ble     t0, t3, restore_char
    ble     t0, t2, to_downcase
 
maybe_capitalize:
    bnez    a1, capitalize
 
restore_char:
    addi    t0, t0, 32
 
    or      t0, t0, a2                     ; apply mask
 
store_symbol:
    lui     t2, 0                          ; restore t2 to 0
    lui     t3, 0                          ; restore t3 to 0
 
    sw      t0, 0(a4)                      ; store character to buffer
 
    addi    a4, a4, 1                      ; buf_addr += 1
    addi    a6, a6, -1                     ; buf_size -= 1
    addi    t1, t1, 1                      ; index += 1
 
    beq     a6, zero, overflow             ; if buf_size == 0 ==> overflow
 
 
    j       read_and_capitalize
 
set_capitalize_flag:
    lui     a1, 1
    j       restore_char
 
to_downcase:
    addi    t0, t0, 32
    j       maybe_capitalize
 
capitalize:
    lui     a1, 0
    j       store_symbol
 
overflow:
    lui     a0, 1
    j       end
 
success:
    lui     t2, %hi(str_len)               ; t2 <-- str_len:addr
    addi    t2, t2, %lo(str_len)
    sb      t1, 0(t2)                      ; str_len <-- index (message size)
    lui     a0, 0
    sb 	    a0, 0(a4)
 
end:
    jr      ra
 
 
output_overflow:
    lui     a0, %hi(output_addr)           ; int * output_addr_const = *output_addr;
    addi    a0, a0, %lo(output_addr)
    lw      a0, 0(a0)                      ; int output_addr = *output_addr_const;
 
    lui     a1, %hi(overflow_sign)         ; a1 <-- overflow_sign
    addi    a1, a1, %lo(overflow_sign)
    lw      a1, 0(a1)
 
    sw      a1, 0(a0)
    j       end
 
output_buf:
    lui     a0, %hi(output_addr)           ; int * output_addr_const = *output_addr;
    addi    a0, a0, %lo(output_addr)
 
    lw      a0, 0(a0)                      ; int output_addr = *output_addr_const;
 
    lui     a1, 0
    addi    a1, a1, buf
 
    lui     a2, %hi(str_len)
    addi    a2, a2, %lo(str_len)
 
    addi    a3, a3, 0x000ff
 
    lw      a2, 0(a2)
    and     a2, a2, a3
 
    ; a0 -- output_addr
    ; a1 -- ptr
    ; a2 -- n (str_len)
    ; a3 -- tmp
 
while:
    beqz    a2, end                        ; while (acc != 0) {
    addi    a2, a2, -1                     ;   n--
 
    lw      a3, 0(a1)                      ;   tmp = *buf
    addi    a4, zero, 255
    and     a3, a3, a4			   ;   a3 &= 0xff
    beqz    a3, end                        ;   if (a3 == '\0') goto end
    sb      a3, 0(a0)                      ;   *output_addr = tmp;
 
    addi    a1, a1, 1                      ;   ptr++
 
    j       while                          ; }

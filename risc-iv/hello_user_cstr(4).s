    .data
buffer:          .byte  'Hello, _________________________'
padding:         .byte  '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
greet:           .byte  'What is your name?\n\0\0\0\0'
 
    .text
_start:
    addi     s2, s2, 0x21
    lui      s3, %hi(0xFFFF0000)
    addi     s3, s3, %lo(0xFFFF0000)         ; exclamation mark + zero-byte mask
    lui      a0, %hi(greet)
    addi     a0, a0, %lo(greet)
    mv       s1, a0
    jal      ra, strlen
    mv       a1, a0
    mv       a0, s1
    jal      ra, write                       ; write(greet, strlen(greet))
 
    mv       a0, zero
    mv       a1, zero
    addi     a0, a0, 7
    addi     a1, a1, 24
    jal      ra, readline                    ; readline(buffer + 7, 24)
    addi     a0, a0, -23                     ; is there space for exclamation mark?
    beqz     a0, overflow                    ; no -> post 0xCC and die
 
 
    mv       a0, zero
    jal      ra, strlen
    mv       a1, a0
    lw       a0, 0(a1)
    and      a0, a0, s3
    or       a0, a0, s2
    sw       a0, 0(a1)                       ; append(buffer, "!");
 
    mv       a0, zero
    jal      ra, strlen
    mv       a1, a0
    mv       a0, zero
    jal      ra, write                       ; write(buffer, strlen(buffer))
    halt
 
overflow:
    lui      a0, %hi(0xCCCCCCCC)
    addi     a0, a0, %lo(0xCCCCCCCC)
    sw       a0, 0x84(zero)
    halt
 
strlen:
    mv       t0, zero
    addi     t0, t0, 0xFF                    ; byte mask
    mv       a1, zero
 
strlen_loop:
    add      a2, a0, a1
    lw       a2, 0(a2)
    and      a2, a2, t0
    addi     a1, a1, 1
    bnez     a2, strlen_loop                 ; run until zero-byte is met
    addi     a0, a1, -1                      ; exclue zero-byte from final result
    jr       ra
 
write:
    mv       t0, zero
    addi     t0, t0, 0xFF                    ; t0 = 0xFF (byte mask)
    beqz     a1, write_end                   ; Exit if length == 0
 
write_loop:
    lw       a2, 0(a0)                       ; Load word
    and      a2, a2, t0                      ; Extract byte
    sw       a2, 0x84(zero)                  ; Output byte
    addi     a0, a0, 1                       ; Next byte
    addi     a1, a1, -1                      ; Decrement length
    bnez a1, write_loop                      ; Loop if more bytes
 
write_end:
    jr ra                                    ; Return
 
 
readline:
    mv       t0, zero
    addi     t0, t0, 0xFF                    ; byte mask
    lui      t1, %hi(0xFFFFFF00)
    addi     t1, t1, %lo(0xFFFFFF00)         ; non-destructive byte store mask
    addi     a2, a1, -1
    beqz     a2, readline_end                ; fail if there is only space for zero byte
    mv       a1, zero                        ; total bytes written
    mv       a3, zero
    addi     a3, a3, 0xA                     ; LF character
 
readline_loop:
    lw       a4, 0x80(zero)                  ; get last dword from IO port
    and      a5, a4, t0                      ; mask with 0xFF
    beq      a5, a3, readline_lf             ;
    add      a5, a0, a1                      ; calculate current byte to set
    addi     a1, a1, 1                       ; increment bytes counter
    lw       a6, 0(a5)
    and      a6, a6, t1
    or       a4, a6, a4
    sw       a4, 0(a5)                       ; store the byte in buffer, retaining higher ones
    bne      a2, a1, readline_loop           ; continue if buffer has enough space
    mv       a1, a2
 
readline_lf:
    add      a0, a0, a1
    lw       a2, 0(a0)
    and      a2, a2, t1
    sw       a2, 0(a0)                       ; append zero-byte to output
    mv       a0, a1
    jr       ra                              ; return total bytes written
 
readline_end:
    lw       a2, 0(a0)
    and      a2, a2, t1
    sw       a2, 0(a0)
    mv       a0, zero
    jr       ra

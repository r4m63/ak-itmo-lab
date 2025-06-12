    .data
buffer:          .byte  '________________________________'
padding:         .byte  '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
 
.text
_start:
    addi     sp, zero, 0x500	; init stack pointer
 
    mv       a0, zero		; a0 <-- buffer address
    mv       a1, zero
    addi     a1, a1, 33		; a1 <-- max input length
    jal      ra, readline
    beqz     a0, overflow	; if return == 0 --> overflow
 
    mv       a0, zero		; a0 <-- buffer address
    jal      ra, uc		; convert lower case to uppercase
 
    mv       a0, zero		; a0 <-- buffer address
    jal      ra, strlen
    mv       a1, a0		; a1 = string length
    mv       a0, zero		; a0 <-- buffer address
    jal      ra, write		; print string
    halt
 
overflow:
    mv       a0, zero
    addi     a0, a0, 0xCC
    sw       a0, 0x84(zero)
    halt
 
strlen:
    mv       t0, zero
    addi     t0, t0, 0xFF
    mv       a1, zero
 
strlen_loop:
    add      a2, a0, a1
    lw       a2, 0(a2)
    and      a2, a2, t0
    addi     a1, a1, 1
    bnez     a2, strlen_loop
    addi     a0, a1, -1
    jr       ra
 
write:
    mv       t0, zero
    addi     t0, t0, 0xFF
    beqz     a1, write_end
    addi     sp, sp, -16
    sw       ra, 12(sp)
    lw       a2, 0(a0)
    and      a2, a2, t0
    addi     a0, a0, 1
    sw       a2, 0x84(zero)
    addi     a1, a1, -1
    jal      ra, write
    lw       ra, 12(sp)
    addi     sp, sp, 16
 
write_end:
    jr       ra
 
readline:
    mv       t0, zero
    addi     t0, t0, 0xFF	; byte mask
    lui      t1, %hi(0xFFFFFF00)
    addi     t1, t1, %lo(0xFFFFFF00)	; mask for upper bytes
    addi     a2, a1, -1		; a2 = max chars to read
    beqz     a2, readline_end	; if a2 == 0 --> readline_end
    mv       a1, zero		; a1 - counter
    mv       a3, zero
    addi     a3, a3, 0xA	; a3 <-- '\n'
 
readline_loop:
    lw       a4, 0x80(zero)	; read char
    and      a5, a4, t0		; masking char & 0xFF
    beq      a5, a3, readline_lf; end of input
    add      a5, a0, a1		; buffer_addr++
    addi     a1, a1, 1		; counter++
    lw       a6, 0(a5)		; read word from buffer
    and      a6, a6, t1		; clear lower byte
    or       a4, a6, a4		; adding reading byte to buffer by OR: 0xaabbcc00 | 0x000000dd --> a4
    sw       a4, 0(a5)		; saving this byte to buf
    bne      a2, a1, readline_loop
    lui      a0, %hi(0xCCCCCCCC)
    addi     a0, a0, %lo(0xCCCCCCCC)
    sw       a0, 0x84(zero)
    halt
 
readline_lf:
    add      a0, a0, a1
    lw       a2, 0(a0)
    and      a2, a2, t1
    sw       a2, 0(a0)
    mv       a0, a1
    jr       ra
 
readline_end:
    lw       a2, 0(a0)
    and      a2, a2, t1
    sw       a2, 0(a0)
    mv       a0, zero
    jr       ra
 
uc:
    mv       t6, zero
    addi     t6, t6, 0xFF
    mv       t0, a0
 
uc_loop:
    lw       t1, 0(t0)
    and      t1, t1, t6
    beqz     t1, uc_end
 
    mv       t2, zero
    addi     t2, t2, 0x61
    beq      t1, t2, uc_eq
    ble      t1, t2, uc_skip
 
uc_eq:
    mv       t2, zero
    addi     t2, t2, 0x7A
    bgt      t1, t2, uc_skip
 
    addi     t1, t1, -32
 
 
    lw       t3, 0(t0)
 
 
    lui      t4, %hi(0xFFFFFF00)
    addi     t4, t4, %lo(0xFFFFFF00)
 
    and      t5, t3, t4
    or       t5, t5, t1
    sw       t5, 0(t0)
 
uc_skip:
    addi     t0, t0, 1
    j        uc_loop
 
uc_end:
    jr       ra

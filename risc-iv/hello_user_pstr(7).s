    .data
.org 0x00
buf:             .byte  '________________________________'
output_addr:     .word  0x84               ; Output address where the result should be stored
input_addr:      .word  0x80               ; Address to read input
 
first_line:      .byte 19, 'What is your name?\n'
greeting:        .byte 7, 'Hello, '
end_of_output:   .byte 1, '!'
 
const_stop_symbol:     .byte '\n'
const_max_input_len:   .word 23            ; 32 (buf size) - 7 (len of greeting) - 1 (len of "!") - 1 (space for str length)
const_mask1:           .word 0x000000FF
const_mask2:           .word 0xFFFFFF00
err_overflow:          .word 0xCCCCCCCC
 
 
    .text
.org 0x100
_start:
    addi    sp, sp, 800                     ; kostyil
 
    lui     s1, %hi(output_addr)            
    addi    s1, s1, %lo(output_addr)
    lw      s1, 0(s1)                       ; s1 = output address
    mv      t0, s1                          ; t0 is also output address
 
    addi    t1, t1, first_line              ; t1 = pointer to line we print
 
    jal     ra, print_pascal_string         ; first_line is now in output 
 
 
    lui     t3, %hi(buf)
    addi    t3, t3, %lo(buf)                ; t3 is pointer to buffer
 
    sb      zero, 0(t3)                     ; buffer is pstr with length 0
 
    lui     t4, %hi(greeting)
    addi    t4, t4, %lo(greeting)           ; t4 is pointer to greeting
 
    jal     ra, add_string_to_pstr          ; greeting is copied to buffer
 
    lui     t4, %hi(const_max_input_len)
    addi    t4, t4, %lo(const_max_input_len)
    lw      t4, 0(t4)                       ; t4 contains max input length
 
    lui     t5, %hi(input_addr)
    addi    t5, t5, %lo(input_addr)
    lw      t5, 0(t5)                       ; t5 is pointer to user input source
 
    lui     t3, %hi(buf)
    addi    t3, t3, %lo(buf)                ; t3 is pointer to buffer
 
    lui     t1, %hi(const_stop_symbol)
    addi    t1, t1, %lo(const_stop_symbol)
    jal     ra, load_byte
    mv      t6, t2                          ; t6 contains stop symbol
 
    jal     ra, read_user_input             ; user input was added to buffer
 
 
    lui     t4, %hi(end_of_output)
    addi    t4, t4, %lo(end_of_output)      ; t4 is pointer to greeting; t3 still points on buffer
 
    jal     ra, add_string_to_pstr          ; "!" was added to buffer
 
    lui     t1, %hi(buf)
    addi    t1, t1, %lo(buf)                ; t1 points on buffer
 
    mv      t0, s1                          ; t0 still on output address
 
    jal     ra, print_pascal_string         ; print buffer
 
 
    halt
 
;;;;;;;;;;;;;
 
; args: t0 - output addr, t1 - pointer to pascal string, return: nothing
print_pascal_string:
    addi    sp, sp, -4
    sw      ra, 0(sp)                       ; save ra to make a call 
 
    jal     ra, load_byte                   ; t2 now contains pascal string size
 
    addi    t1, t1, 1                       ; move ptr to the first symbol to print 
 
    print_cycle:
        beqz    t2, print_end               ; check if there are symbols left
        addi    t2, t2, -1                  ; decrement symbols left counter
 
        lw      tp, 0(t1)                   ; load symbol
        sb      tp, 0(t0)                   ; print it 
 
        addi    t1, t1, 1                   ; move ptr to the next symbol
 
        j print_cycle                       ; next iteration 
 
    print_end:
        lw      ra, 0(sp)                   ; restore ra
        addi    sp, sp, 4                   ; restore sp
 
        jr      ra                          ; return 
 
 
 
; args: t1 - pointer to memory from where read, return: t2 - result of reading 
load_byte:
    lw      t2, 0(t1)                       ; load word
 
    addi    tp, zero, 0xff                  ; mask
    and     t2, t2, tp                      ; now t2 contains only last byte 
 
    jr      ra                              ; return 
 
 
 
; args: a0 - symbol to save, a1 - address, returns: nothing
store_byte:
    lw      a2, 0(a1)                       ; load word
 
    lui     a3, %hi(const_mask2)
    addi    a3, a3, %lo(const_mask2)
    lw      a3, 0(a3)                       
 
    and     a2, a2, a3                      ; save higher bytes of original data in memory
 
    lui     a3, %hi(const_mask1)
    addi    a3, a3, %lo(const_mask1)
    lw      a3, 0(a3)
 
    and     a0, a0, a3                      ; lower byte of data to save
 
    add     a0, a0, a2                      ; combine data
 
    sw      a0, 0(a1)                       ; save data
 
    jr      ra                              ; return 
 
 
 
; args: t3 - pointer to pstr, t4 - pointer to pstr to add
add_string_to_pstr:
    addi    sp, sp, -16                     ; save registers
    sw      s2, 0(sp)
    sw      ra, 4(sp)
    sw      s3, 8(sp)
 
    mv      t1, t3
    jal     ra, load_byte                   
    mv      s2, t2                          ; s2 now contains first pstr size
 
    mv      t1, t4
    jal     ra, load_byte                   ; t2 now contains second pstr size
 
    add     s3, s2, t2                      ; s3 is a length of both strings
    mv      a0, s3
    mv      a1, t3
    jal     ra, store_byte                  ; save the length
 
    addi    t3, t3, 1
    add     t3, t3, s2                      ; t3 is now pointer to the first free element in buffer with pstr1
 
    addi    t4, t4, 1                       ; t4 is pointer to the first pstr2 symbol
 
 
    copy_cycle:
        beqz    t2, add_string_end          ; check if pstr2 has symbols left
        addi    t2, t2, -1                  ; decrement symbols left counter
 
        lw      tp, 0(t4)
 
        mv      a0, tp
        mv      a1, t3
        jal     ra, store_byte              ; copy current symbol
 
        addi    t3, t3, 1
        addi    t4, t4, 1                   ; move pointers
 
        j       copy_cycle                  ; next iteration
 
 
    add_string_end:
        lw      s2, 0(sp)
        lw      ra, 4(sp)
        lw      s3, 8(sp)
        addi    sp, sp, 16                  ; restore registers and stack
 
        jr      ra                          ; return
 
 
 
; t3 - pointer to buffer to save input, t4 - max user input size, t5 - input address, t6 - stop_symbol, return nothing
read_user_input:
    addi    sp, sp, -16                      ; save registers
    sw      s2, 0(sp)
    sw      ra, 4(sp)
    sw      s3, 8(sp)
 
    mv      t1, t3
    jal     ra, load_byte                   ; t2 now contains cur buf length
 
    add     s2, t3, t2
    addi    s2, s2, 1                       ; s2 is pointer to first free element in buffer
 
    mv      s3, zero                        ; s3 is counter of readen symbols
 
    read_cycle:
        beq     s3, t4, read_end_overflow   ; if there is no space left 
        addi    s3, s3,  1                  ; increment counter of readen symbols
 
        lw      tp, 0(t5)                   ; read symbol
 
        beq     tp, t6, read_end            ; stop symbol found
 
        mv      a0, tp
        mv      a1, s2
        jal     ra, store_byte              ; save symbol
 
        addi    s2, s2, 1                   ; move ptr
 
        j read_cycle                        ; next iteration
 
    read_end:
        add     t2, t2, s3                  ; t2 - previous pstr length, s3 - number of readen symbols
        addi    t2, t2, -1                  ; -1 because last symbol was '\n' 
        mv      a0, t2
        mv      a1, t3
        jal     ra, store_byte              ; update pstr 
 
        lw      s2, 0(sp)                   ; restore registers and stack
        lw      ra, 4(sp)
        lw      s3, 8(sp)
        addi    sp, sp, 16
 
        jr      ra                          ; return
 
    read_end_overflow:
        addi    t1, zero, err_overflow      ; t1 is pointer to err_overflow message
        lw      t1, 0(t1)                   ; t1 is err_overflow message
 
        sw      t1, 0(s1)                   ; print overflow message
 
        halt

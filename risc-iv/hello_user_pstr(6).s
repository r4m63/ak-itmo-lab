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
    lui     sp, %hi(0x500)    
    addi    sp, sp, %lo(0x500)
 
    lui     s1, %hi(output_addr)            
    addi    s1, s1, %lo(output_addr)
    lw      s1, 0(s1)                       ; s1 = output address
    mv      a0, s1                          ; a0 is also output address
 
    addi    a1, zero, first_line            ; a1 = pointer to line we print
 
    jal     ra, print_pascal_string         ; first_line is now in output 
 
 
    lui     a0, %hi(buf)
    addi    a0, a0, %lo(buf)                ; a0 is pointer to buffer
 
    sb      zero, 0(a0)                     ; buffer is pstr with length 0
 
    lui     a1, %hi(greeting)
    addi    a1, a1, %lo(greeting)           ; a1 is pointer to greeting
 
    jal     ra, add_string_to_pstr          ; greeting is copied to buffer
 
 
    lui     a0, %hi(const_stop_symbol)
    addi    a0, a0, %lo(const_stop_symbol)
    jal     ra, load_byte
    mv      a3, a1                          ; a3 contains stop symbol
 
    lui     a1, %hi(const_max_input_len)
    addi    a1, a1, %lo(const_max_input_len)
    lw      a1, 0(a1)                       ; a1 contains max input length
 
    lui     a2, %hi(input_addr)
    addi    a2, a2, %lo(input_addr)
    lw      a2, 0(a2)                       ; a2 is a pointer to user input source
 
    lui     a0, %hi(buf)
    addi    a0, a0, %lo(buf)                ; a0 is a pointer to buffer
 
    jal     ra, read_user_input             ; user input was added to buffer
 
 
    lui     a0, %hi(buf)
    addi    a0, a0, %lo(buf)                ; a0 is a pointer to buffer
 
    lui     a1, %hi(end_of_output)
    addi    a1, a1, %lo(end_of_output)      ; a1 is pointer to "!"
 
    jal     ra, add_string_to_pstr          ; "!" was added to buffer
 
 
    lui     a1, %hi(buf)
    addi    a1, a1, %lo(buf)                ; a1 points on buffer
 
    mv      a0, s1                          ; a0 points on output address
 
    jal     ra, print_pascal_string         ; print buffer
 
 
    halt
 
;;;;;;;;;;;;;
 
; args: a0 - output addr, a1 - pointer to pascal string, returns: nothing
print_pascal_string:
    addi    sp, sp, -16
    sw      ra, 0(sp)                       ; save ra to make a call
    sw      s0, 4(sp)                       ; save registers
    sw      s1, 8(sp)
 
    mv      s0, a0
    mv      s1, a1                          ; free a0-a1 for next use 
 
    mv      a0, a1                          ; prepare arg for load_byte call
    jal     ra, load_byte                   ; a1 now contains pascal string size
 
    addi    s1, s1, 1                       ; move ptr to the first symbol to print 
 
    print_cycle:
        beqz    a1, print_end               ; check if there are symbols left
        addi    a1, a1, -1                  ; decrement symbols left counter
 
        lw      tp, 0(s1)                   ; load symbol
        sb      tp, 0(s0)                   ; print it 
 
        addi    s1, s1, 1                   ; move ptr to the next symbol
 
        j print_cycle                       ; next iteration 
 
    print_end:
        lw      ra, 0(sp)
        lw      s0, 4(sp)
        lw      s1, 8(sp)                   ; restore registers
        addi    sp, sp, 4                   ; restore sp
 
        jr      ra                          ; return 
 
 
 
; args: a0 - pointer to memory from where read, returns: a1 - result of reading 
load_byte:
    lw      a1, 0(a0)                       ; load word
 
    addi    t1, zero, 0xff                  ; mask
    and     a1, a1, t1                      ; now a1 contains only last byte 
 
    jr      ra                              ; return 
 
 
 
; args: a0 - symbol to save, a1 - address, returns: nothing
store_byte:
    lw      t1, 0(a1)                       ; load word
 
    lui     t2, %hi(const_mask2)
    addi    t2, t2, %lo(const_mask2)
    lw      t2, 0(t2)                       ; load mask
 
    and     t1, t1, t2                      ; save higher bytes of original data in memory
 
    lui     t2, %hi(const_mask1)
    addi    t2, t2, %lo(const_mask1)
    lw      t2, 0(t2)                       ; load mask
 
    and     a0, a0, t2                      ; lower byte of data to save
 
    add     a0, a0, t1                      ; combine data
 
    sw      a0, 0(a1)                       ; save data
 
    jr      ra                              ; return 
 
 
 
; args: a0 - pointer to pstr, a1 - pointer to pstr to add, returns nothing
add_string_to_pstr:
    addi    sp, sp, -24                     ; save registers
    sw      s2, 0(sp)
    sw      ra, 4(sp)
    sw      s3, 8(sp)
    sw      s0, 12(sp)
    sw      s1, 16(sp)
    sw      s4, 20(sp)
 
    mv      s0, a0
    mv      s1, a1                          ; save args 
 
    jal     ra, load_byte                   
    mv      s2, a1                          ; s2 now contains first pstr size
 
    mv      a0, s1
    jal     ra, load_byte
    mv      s4, a1                          ; s4 now contains second pstr size
 
    add     s3, s2, s4                      ; s3 is a length of both strings
    mv      a0, s3
    mv      a1, s0
    jal     ra, store_byte                  ; save the length
 
    addi    s0, s0, 1
    add     s0, s0, s2                      ; s0 is now pointer to the first free element in buffer with pstr1
 
    addi    s1, s1, 1                       ; t4 is pointer to the first pstr2 symbol
 
 
    copy_cycle:
        beqz    s4, add_string_end          ; check if pstr2 has symbols left
        addi    s4, s4, -1                  ; decrement symbols left counter
 
        lw      t1, 0(s1)
 
        mv      a0, t1
        mv      a1, s0
        jal     ra, store_byte              ; copy current symbol
 
        addi    s0, s0, 1
        addi    s1, s1, 1                   ; move pointers
 
        j       copy_cycle                  ; next iteration
 
 
    add_string_end:
        lw      s2, 0(sp)
        lw      ra, 4(sp)
        lw      s3, 8(sp)
        lw      s0, 12(sp)
        lw      s1, 16(sp)
        lw      s4, 20(sp)
        addi    sp, sp, 24                  ; restore registers and stack
 
        jr      ra                          ; return
 
 
 
; t3 - pointer to buffer to save input, t4 - max user input size, t5 - input address, t6 - stop_symbol, return nothing
; a0 - pointer to buffer to save input, a1 - max user input size, a2 - input address, a3 - stop_symbol, returns nothing
read_user_input:
    addi    sp, sp, -32                      ; save registers
    sw      s2, 0(sp)
    sw      ra, 4(sp)
    sw      s3, 8(sp)
    sw      s0, 12(sp)
    sw      s1, 16(sp)
    sw      s4, 20(sp)
    sw      s5, 24(sp)
    sw      s6, 28(sp)
 
    mv      s0, a0
    mv      s1, a1
    mv      s4, a2
    mv      s5, a3                          ; save args
 
    jal     ra, load_byte                   ; a1 now contains cur buf length
    mv      s6, a1                          ; save cur buf length to s6
 
    add     s2, s0, a1
    addi    s2, s2, 1                       ; s2 is pointer to first free element in buffer
 
    mv      s3, zero                        ; s3 is a counter of readen symbols
 
    read_cycle:
        beq     s3, s1, read_end_overflow   ; if there is no space left 
        addi    s3, s3, 1                   ; increment counter of readen symbols
 
        lw      t1, 0(s4)                   ; read symbol
 
        beq     t1, s5, read_end            ; stop symbol found
 
        mv      a0, t1
        mv      a1, s2
        jal     ra, store_byte              ; save symbol
 
        addi    s2, s2, 1                   ; move ptr
 
        j read_cycle                        ; next iteration
 
    read_end:
        add     s6, s6, s3                  ; s6 - previous pstr length, s3 - number of readen symbols
        addi    s6, s6, -1                  ; -1 because last symbol was '\n' 
        mv      a0, s6
        mv      a1, s0
        jal     ra, store_byte              ; update pstr 
 
        lw      s2, 0(sp)                   ; restore registers and stack
        lw      ra, 4(sp)
        lw      s3, 8(sp)
        lw      s0, 12(sp)
        lw      s1, 16(sp)
        lw      s4, 20(sp)
        lw      s5, 24(sp)
        lw      s6, 28(sp)
        addi    sp, sp, 32
 
        jr      ra                          ; return
 
    read_end_overflow:
        addi    t1, zero, err_overflow      ; t1 is pointer to err_overflow message
        lw      t1, 0(t1)                   ; t1 is err_overflow message
 
        lw      s1, 16(sp)                  ; restore s1 = output address 
        addi    sp, sp, 20
 
        sw      t1, 0(s1)                   ; print overflow message
 
        halt

.data
.org 0x00
buffer:                 .byte       '________________________________'
 
.data
.org 0x100 
input_addr:             .word       0x80
output_addr:            .word       0x84
stack_start:            .word       0x600
buffer_start:           .word       0x01
newline_char:           .word       10
max_chars:              .word       31
uppercase_limit:        .word       90
lowercase_diff:         .word       32
handle_overflow_value:         .word       0xCCCCCCCC
char_mask:              .word       0xffffff00
input_mask:             .word       0x000000ff
char_prefix_mask:       .word       0x5f5f5f00
zero:                   .word       0x00
 
.text
.org        0x200
_start:
    lui     sp, %hi(stack_start) ; stack_start -> sp
    addi    sp, sp, %lo(stack_start)
    lw      sp, 0(sp)
 
    lui     gp, %hi(buffer_start) ; buffer_start -> gp
    addi    gp, gp, %lo(buffer_start)
    lw      gp, 0(gp)
 
    jal     ra, input_loop               ; input -> buffer 
 
    lui     tp, %hi(zero) ; 0 -> buffer pointer
    addi    tp, tp, %lo(zero)
    lw      tp, 0(tp)
 
    jal     ra, print_buffer           ; buffer -> output
    halt
 
handle_overflow:
    lui     t1, %hi(output_addr); output_addr -> t1
    addi    t1, t1, %lo(output_addr)
    lw      t1, 0(t1)
 
    lui     t2, %hi(handle_overflow_value); handle_overflow_value -> t2
    addi    t2, t2, %lo(handle_overflow_value)
    lw      t2, 0(t2)
    sw      t2, 0(t1)                   ; t2-> output
    halt
 
input_loop:                              
    sw      ra, 0(sp)                   ; save return address
    addi    sp, sp, 4                   ; sp++
 
    lui     s0, %hi(zero) ; 0 -> loop counter
    addi    s0, s0, %lo(zero)
    lw      s0, 0(s0)
 
    lui     t3, %hi(newline_char); '\n' -> t3
    addi    t3, t3, %lo(newline_char)
    lw      t3, 0(t3)
 
    lui     t4, %hi(max_chars) ; max_chars -> t4
    addi    t4, t4, %lo(max_chars)
    lw      t4, 0(t4)
 
input_loop_body:
    jal     ra, read_input_char         ; input -> a0
 
    beq     a0, t3, finalize_input      ; ? a0 == '\n'
    beq     s0, t4, handle_overflow     ; ? handle_overflow            
 
    jal     ra, to_uppercase_a0           
    jal     ra, write_a0_to_buffer          
    addi    s0, s0, 1                   ; loop counter++
    j       input_loop_body              
 
finalize_input:
    lui     gp, %hi(zero)
    addi    gp, gp, %lo(zero)
    lw      gp, 0(gp)
 
    lw      t4, 0(gp)                   ;  mem[gp] -> t4
 
    lui     t3, %hi(char_mask) ; char_mask -> t3
    addi    t3, t3, %lo(char_mask)
    lw      t3, 0(t3)
 
    and     t4, t4, t3;
    add     s0, s0, t4                  ; 0x5f5f5f00 + count -> s0
    sw      s0, 0(gp)                   ; s0 -> buf start
 
    addi    sp, sp, -4                  ;return 
    lw      ra, 0(sp)                   
    jr      ra                          
 
read_input_char:                        
    lui     a0, %hi(input_addr)
    addi    a0, a0, %lo(input_addr)
    lw      a0, 0(a0)
    lw      a0, 0(a0)                  
    jr      ra                          
 
to_uppercase_a0:                          
    lui     a1, %hi(uppercase_limit)    ; 'Z' ->a1
    addi    a1, a1, %lo(uppercase_limit)
    lw      a1, 0(a1)
 
    ble     a0, a1, to_uppercase_a0_end   ; ? a0 <= 'Z'
 
    lui     t0, %hi(lowercase_diff)     ; a0-=32
    addi    t0, t0, %lo(lowercase_diff)
    lw      t0, 0(t0)
    sub     a0, a0, t0                  
 
to_uppercase_a0_end:
    jr      ra                          
 
write_a0_to_buffer:                         
    lui     a2, %hi(char_prefix_mask)   ; char_prefix_mask -> a2
    addi    a2, a2, %lo(char_prefix_mask)
    lw      a2, 0(a2)
 
    or      a4, a0, a2                  ; filling with 5f
    sw      a4, 0(gp)                   ; save symbol
    addi    gp, gp, 1                   ; counter++
    jr      ra                          
 
print_buffer:                          
    lw      s1, 0(tp)                   ; count of chars -> s1
 
    lui     a2, %hi(input_mask)         ; 0x000000ff -> a2
    addi    a2, a2, %lo(input_mask)
    lw      a2, 0(a2)
 
    and     s1, s1, a2                  ; 0x5f5f5f00 + count -> 0x00000000 + count
    addi    tp, tp, 1                   ; pointer++
 
    lui     t2, %hi(output_addr)        ; output_addr -> t2
    addi    t2, t2, %lo(output_addr)
    lw      t2, 0(t2)
 
print_loop:
    lw      t4, 0(tp)                   ; symbol -> output
    sb      t4, 0(t2)                   
    addi    tp, tp, 1                   ; buf pointer++
    addi    s1, s1, -1                  ; loop counter--
    bnez    s1, print_loop              ; ? loop counter != 0
 
    jr      ra

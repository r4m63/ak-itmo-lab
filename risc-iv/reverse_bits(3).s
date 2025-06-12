.data
    in_addr:       .word 0x80
    out_addr:      .word 0x84
    bit_mask:      .word 0x00000001
    loop_limit:    .word 31
 
.text
_start:
    ; s0 - input
    ; s1 - result
    ; s2 - bit mask
    ; s3 - temp bit
    ; s4 - bit shift amount (1)
    ; s5 - counter
 
    ; Load address of input value
    lui a0, %hi(in_addr)
    addi a0, a0, %lo(in_addr)
    lw a0, 0(a0)
    lw s0, 0(a0)         ; Load actual input value into s0
 
    ; Load bit mask
    lui a1, %hi(bit_mask)
    addi a1, a1, %lo(bit_mask)
    lw s2, 0(a1)
 
    ; Load loop count
    lui a2, %hi(loop_limit)
    addi a2, a2, %lo(loop_limit)
    lw s5, 0(a2)
 
    ; Initialize bit shift constant
    addi s4, zero, 1
 
    ; Clear result register
    mv s1, zero
 
bit_reverse_loop:
    ; Isolate the lowest bit
    and s3, s0, s2
 
    ; Merge bit into result
    add s1, s1, s3
 
    ; Exit condition
    beqz s5, write_output
 
    ; Shift result and input
    sll s1, s1, s4
    srl s0, s0, s4
 
    ; Decrease counter
    addi s5, s5, -1
 
    j bit_reverse_loop
 
write_output:
    ; Load output address
    lui a3, %hi(out_addr)
    addi a3, a3, %lo(out_addr)
    lw a3, 0(a3)
 
    ; Store the result
    sw s1, 0(a3)
 
    halt

    .data
    .org 0x90
input_addr:      .word  0x80          
output_addr:     .word  0x84       
    .text
 
_start:
    lui      t0, %hi(input_addr)             
    addi     t0, t0, %lo(input_addr)  
 
 
    lw       t0, 0(t0)                      
 
    lw       t1, 0(t0)  
 
    ; make t3 a pointer to stack top
    lui      t3, %hi(stack)             
    addi     t3, t3, %lo(stack) 
 
     ; make a1 a permanent pointer to start of stack
    lui      a1, %hi(stack)             
    addi     a1, a1, %lo(stack) 
 
 
    ; make a0 const 1
    lui      a0, %hi(1)             
    addi     a0, a0, %lo(1)  
 
    ; make t4 const 0
    lui      t4, %hi(0)             
    addi     t4, t4, %lo(0) 
 
 
    bgt      t4,t1,negative
 
    ; make t5 const 0
    lui      t5, %hi(4)             
    addi     t5, t5, %lo(4) 
 
    ; make s4 const 4
    lui      s4, %hi(4)             
    addi     s4, s4, %lo(4)  
 
    ;pointer to map
    lui      s2, %hi(map)             
    addi     s2, s2, %lo(map)
 
 
    j        fibonachi
 
check_if_known:
 
    mul t6,t1,s4
 
    add      s3, s2, t6  
    lw       s3,0(s3)
 
    add      t2,t2,s3
 
    jr       t0
 
 
 
 
put_on_stack:
    addi  t3,t3,1
    add   t0,t0,t5
    ; add pc+1 to stack
    sw     t0,0(t3)
    addi   t3,t3,2
    ;add   t1 to stack
    sw     t1,0(t3)
 
    sub    t0, t0, t5
 
    jr     t0
return:
    beq    t3,a1,end ; if returning with empty stack jump to end
 
    ; restore t1
    lw     t1, 0(t3)
    sw     t4, 0(t3)
    sub    t3,t3,a0
    ; restore pc
    sub    t3,t3,a0   
    lw     t0, 0(t3)   
    sw     t4, 0(t3)
    sub    t3,t3,a0
 
    ; add known value to map
    mul t6,t1,s4
    add      s3, s2, t6  
    sw       t2,0(s3)
 
    jr     t0
 
 
fibonachi:
 
check_0:
    bnez     t1, check_1 ; if t1 == 0 add 0 to t2
    addi     t2, t2, 0   
    j        return
check_1:
    bne      t1,a0,check_rest_1 ; if t1 == 0 add 0 to t2
    addi     t2, t2, 1
    j        return
check_rest_1:
    sub   t1, t1, a0
    jal   t0, check_if_known
    bnez  s3, check_rest_2
    jal   t0, put_on_stack
    j     fibonachi
check_rest_2:
    sub   t1, t1, a0
    jal   t0, check_if_known
    bnez  s3, check_end
    jal   t0, put_on_stack
    j     fibonachi
check_end:
    j     return
 
 
end:
    lui      t0, %hi(output_addr)            
    addi     t0, t0, %lo(output_addr)        
 
    bgt      t4,t2,overflow
    j        print
negative:
    lui      t0, %hi(output_addr)            
    addi     t0, t0, %lo(output_addr)     
 
    lui      t2, %hi(-1)             
    addi     t2, t2, %lo(-1) 
    j        print
overflow:
    lui      t2, %hi(0xCC_CC_CC_CC)             
    addi     t2, t2, %lo(0xCC_CC) 
print:
    lw       t0, 0(t0)                
 
    sw       t2, 0(t0)                     
    halt
 
 
; put stack in memory after program 
    .data
    .org 0x200
stack:           .word  0x00 
; stack in format:
; mem(n):   [pc] - programm counter to return to 
; mem(n+1): [t1] - value that should be in t1 after returning
; ...
    .data
    .org 0x300
; will save already known numbers here
; in form of 16 bit sequence
map:             .word  0x00

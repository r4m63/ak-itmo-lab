.data
input_addr:   .word 0x80      
output_addr:  .word 0x84      
n:            .word 0         
result:       .word 0         
cnt:          .word 32        
bit:          .word 0         
ONE:          .word 1         
inv_flag:     .word 0    
const0:       .word 0      
 
.org 0x88
.text
_start:
    load_ind    input_addr    
    store       n             
 
    load        n             
    ble         write_orig    
 
    load        n             
    and         ONE
    store       inv_flag
 
    load        const0             
    store       result
 
reverse_loop:
    load        cnt           ; if cnt == 0 -> done
    beqz        reverse_done
 
    load        n             
    and         ONE
    store       bit
 
    load        n             ; n >>= 1
    shiftr      ONE
    store       n
 
    load        result        ; result = (result << 1) + bit
    shiftl      ONE
    add         bit
    store       result
 
    load        cnt           
    sub         ONE
    store       cnt
 
    jmp         reverse_loop  
 
reverse_done:
    load        inv_flag      ; if inv_flag == 0 -> skip inversion
    beqz        write_out
 
    load        const0             
    sub         result        
    store       result        
    jmp         write_out
 
write_orig:
    load        n             ; for negative input, result = n
    store       result
 
write_out:
    load        result        
    store_ind   output_addr
    halt

.data
    input_addr:      .word  0x80       
    output_addr:     .word  0x84       
    n:               .word  0x00       
    const_1:         .word  0x01       
    const_neg1:      .word  0xFFFFFFFF 
    const_overflow:  .word  0xCCCCCCCC 
 
.text
_start:
    load_ind     input_addr      
    store        n               
 
    load         n               
    beqz         invalid_input   
    ble          invalid_input   
 
    load         n               
    add          const_1         
    bvs          overflow_error  
    mul          n               
    bvs          overflow_error  
    shiftr       const_1         
 
    store_ind    output_addr     
    halt                         
 
invalid_input:
    load         const_neg1      
    store_ind    output_addr     
    halt                         
 
overflow_error:
    load         const_overflow  
    store_ind    output_addr     
    halt

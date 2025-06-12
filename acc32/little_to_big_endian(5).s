    .data
 
input_addr:      .word  0x80               
output_addr:     .word  0x84               
temp1:           .word  0x00              
temp2:           .word  0x00              
OFFSET_SM:       .word  8             
OFFSET_MD:       .word  16                 
XOXO_BYTEMASK:   .word  0xFF00FF00        
OXOX_BYTEMASK:   .word  0x00FF00FF        
OOXX_BYTEMASK:   .word  0x0000FFFF        
 
    .text
_start:
 
    load_ind     input_addr                  
    store        temp2                 
    shiftl       OFFSET_SM                   
    and          XOXO_BYTEMASK              
    store        temp1                       
 
    load         temp2                      
    shiftr       OFFSET_SM                  
    and          OXOX_BYTEMASK              
 
    or           temp1                       
    store        temp2                      
 
    shiftl       OFFSET_MD                   
    store        temp1                        
    load         temp2                       
    shiftr       OFFSET_MD                   
    and          OOXX_BYTEMASK               
    or           temp1                        
    store_ind    output_addr                 
    halt

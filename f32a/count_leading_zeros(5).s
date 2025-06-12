    .data
 
input_addr:     .word 0x80
output_addr:    .word 0x84
mask:           .word 0x80000000
 
    .text
 
_start:
    read_input
    check_0
    enable_eam
    count_leading_zeros
    write_output
 
read_input:
    @p input_addr a! @
    ;
 
check_0:
    dup                 
    if load32
    ;
 
load32:
    drop               
    lit 32              
    write_output ;
 
enable_eam:
    lit 1 eam
    ;
 
count_leading_zeros:
    lit 32 >r        
    lit 0           
    over              
 
count_leading_zeros_loop:
    dup                 
    @p mask             
    and                 
    if left_shift    
    exit ;
 
left_shift:
    2*                 
    over            
    lit 1               
    +                   
    over                
    next count_leading_zeros_loop
 
exit:
    drop               
    r>
    drop
    ;
 
write_output:
    @p output_addr b! !b
 
end:
    halt

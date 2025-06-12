.data
 
buffer: .byte  '________________________________'
input_addr: .word  0x80              
output_addr: .word  0x84              
buffer_addr: .word  0x00              
buffer_size: .word  32                 
 
new_line: .word  -10                
to_capital_const: .word  -32                     
is_low: .word -97
is_capital: .word -65
space: .word 0x20
last_symbol: .word 0x20
zero_symbol: .word 0x00
mask: .word 0x5F5F5F00
error_const: .word  0xCCCCCCCC  
 
 
.text
.org 0x88
 
 
_start:
    @p output_addr b!        
    @p buffer_addr a!       
    @p buffer_size
    lit -1 +
    >r
 
iteration:
    @p 0x80                  
    check_end         
    if string_end
    check_letter
    write_to_buffer        
    next iteration
 
error:
    @p error_const
    !b                       
    halt
 
check_letter:
    dup
	@p is_capital + 			
	-if  if_letter
    ;
 
if_letter:
    dup
    @p is_low + 
    -if previous_symbol
    lit 32 +
 
 
previous_symbol: 
    @p last_symbol
    @p space
    xor
    if make_capital
    ;
 
write_to_buffer: 
	dup
	!p last_symbol
	@p mask +
	!+
    ;   
 
make_capital:
    @p to_capital_const
    +
    ;                                                        
 
check_end:
    dup
    @p new_line +
    ;
 
string_end:
    @p zero_symbol
    write_to_buffer
    @p buffer_addr a!
 
 
write_to_output:
    @+
    lit 0x000000ff and
    dup
    if stop
    !b
    write_to_output ;
 
stop:
    halt

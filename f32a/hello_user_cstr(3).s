    .data
hello_buf:				.byte 'Hello, '
name_buf:             .byte  '_____________________________'
q_buf:			.byte 'What is your name?\n\0'
\ q_buf:			.byte 'W\n\0'
input_addr:     .word  0x80  
output_addr:     .word  0x84   
 
    .text
	.org 0x100
_start:
    @p output_addr b!        
    lit q_buf a!
 
write_while:			\ write question for person
	@+ lit 255 and 
	dup
	if start_read_name
	!b
    write_while ;
 
start_read_name:
    @p input_addr b!        \ read name of person
 
    lit name_buf a!
	lit 23
 
read_while:
    dup
    if overflow                            
    over
 
	@b lit 255 and 
	dup lit -10 +
	if concat
	dup
	if flush_start
 
    !+   
 
	over
    lit -1 +
 
    read_while ;
 
flush_start:	
	over
 
flush_input:		\ clear input
	@b lit 255 and 
	dup lit -10 +
	if concat
 
	drop
 
	flush_input ;
 
concat:
	lit 33 lit 255 and
    !+   
	lit 0x5f5f5f00  
	!+
 
 
start_write_hello:				\ write hello and name of person
    @p output_addr b!       
 
    lit hello_buf a!
 
write_hello_while:
	@+ lit 255 and 
	dup
	if end
	!b
    write_hello_while ;
 
overflow:
    @p output_addr b!                       \ write the special value in output
    lit -858993460 !b
    end ;
 
end:
    halt

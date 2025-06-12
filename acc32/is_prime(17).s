	.data
    .org 0x90
input_addr:     .word 0x80
output_addr: 	.word 0x84
n:	            .word 0x00
i:              .word 0x02
const_1:        .word 0x01
 
	.text
_start:
	load_ind	input_addr
	store	n
    bgt is_one
 
not_in_domain:
    load_imm -1
    store_ind output_addr
    halt
 
is_one:
	sub 	const_1					; check case n equal one
	beqz	is_prime_not_prime
 
is_prime_while:
	load	n
	rem	i
	beqz	is_prime_not_prime
 
	load	i
	add	const_1
	store	i
	mul i			
 
	sub n
 
	bgt is_prime_end ; check i^2 more than n
 
	jmp	is_prime_while          
 
is_prime_not_prime:
	load_imm	0                  	; if number is not prime
	store_ind    output_addr              
	halt
 
is_prime_end:
	load_imm	1                      ; if number is prime
	store_ind    output_addr                
	halt
 
is_prime_overflow:
	load_imm     0xCCCC_CCCC
	store_ind    output_addr               
	halt

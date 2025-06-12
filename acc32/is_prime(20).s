	.data
 
input_addr:    		.word 0x80
output_addr:   		.word 0x84
n: 		   			.word 0x0
quot: 				.word 0x1
mean:				.word 0x0
divisor:			.word 0x2
m_one:				.word -1
zero:				.word 0x0
one: 	   			.word 0x1
two: 				.word 0x2
 
	.text
	.org			0x88
 
_start:
	load_ind 		input_addr
	store			n
	store 			mean
 
	add				m_one
	beqz			it_is_not_prime
	ble				write_minus_one
 
sqrt_Newton_while:
	load			quot
	sub				mean
	bgt 			loop
	beqz 			loop
 
	load			mean
	add				quot
	shiftr			one
	store 			mean
 
	load			n
	div				mean
	store			quot
 
	jmp				sqrt_Newton_while
 
loop:
	load			divisor
	sub  			mean
	bgt 			it_is_prime
 
	load			n
	rem				divisor
	beqz			it_is_not_prime
 
	load			divisor
	add				one
	store 			divisor
 
	jmp				loop
 
write_minus_one:
	load			m_one
	jmp 			is_prime_end
 
it_is_prime:
	load			one
	jmp				is_prime_end
 
it_is_not_prime:
	load			zero
 
is_prime_end:
	store_ind		output_addr
 
is_prime_halt:
	halt

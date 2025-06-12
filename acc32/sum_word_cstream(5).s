	.data
input_addr:			.word 0x80
output_addr: 		.word 0x84
hi_result:			.word 0x0
lo_result: 			.word 0x0
const_one: 			.word 0x1
tmp: 				.word 0x0
 
	.text
_start:
 
while:
	load_ind		input_addr
	beqz			write_output
	store 			tmp
	add				lo_result
	store			lo_result
	load			tmp
	ble				while
	bcs				inc_hi_result
	jmp				while
 
inc_hi_result:
	load			hi_result
	add				const_one
	store			hi_result
	jmp 			while
 
write_output:
	load 			hi_result
	store_ind		output_addr
	load 			lo_result
	store_ind 		output_addr
 
end:
	halt

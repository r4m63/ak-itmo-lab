	.data
n:		   			.word 0x0
result: 		   	.word 0x0
loop_counter:  		.word 0x1
const_one:		   	.word 0x1
const_mns_one:	   	.word -1
input_addr:    		.word 0x80
output_addr:   		.word 0x84
 
	.text
_start:
	load_ind 	input_addr
	store	 	n
 
check_n:
	sub			const_one
	ble			incorrect_input_value
 
loop:
	load		loop_counter
	sub			n
	bgt			write_output
 
	load 		n
	rem			loop_counter
	bnez		continue
 
	load		result
	add			const_one
	store		result
continue:
	load 		loop_counter
	add			const_one
	store 		loop_counter
	jmp 		loop
 
 
incorrect_input_value:
	load		const_mns_one
	store		result	
 
write_output:
	load		result
	store_ind 	output_addr
 
    halt

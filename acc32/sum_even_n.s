	.data
input_addr: .word 0x80
output_addr: .word 0x84
 
one: .word 0x1
const_error: .word -1
const_overflow: .word 0xCCCC_CCCC
 
num: .word 0x0
num_count: .word 0x0 ; для кол-ва членов в сумме (num / 2)
result: .word 0x0
 
	.text
	.org 	0x88
 
_start:
	load_ind 	input_addr
	store 		num
	ble			return_error ; n < 0
	beqz		return_error ; n = 0
	load		num
	and			one
	bnez		make_4et ; нечёт
	jmp			sum ; чёт
 
make_4et:
	load 		num
	sub			one
	store		num
 
sum:
	load		num
	shiftr 		one
	store		num_count
	add			one
	mul 		num_count
	bvs			overflow_error
	store 		result
	jmp 		output
 
return_error:
	load		const_error
	store		result
	jmp			output
 
overflow_error:
	load		const_overflow
	store		result
 
output:
	load		result
	store_ind 	output_addr
	halt

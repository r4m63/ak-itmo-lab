	.data
input_addr:  .word 0x80
output_addr: .word 0x84
result:      .word 0
number:      .word 0
mask:        .word 0x1
shift_amount: .word 0x1
neg_flag:    .word 0
loop_counter: .word 0x0000001F
error_mask:  .word 0xFFFFFFFF
 
.org 0x88
	.text
_start:
    load_ind input_addr
    store number
 
	load number
    ble is_neg
 
	load number
    and mask
    store neg_flag
 
loop_start:
    load result
    shiftl shift_amount
    store result
 
    load number
    and mask
    xor result
    store result
 
    load number
    shiftr shift_amount
    store number
 
    load loop_counter
	beqz is_flag_1
    sub shift_amount
    store loop_counter
	jmp loop_start
 
loop_end:
    load result
    store_ind output_addr
    halt
 
neg_re:
	load result
	xor error_mask
	add shift_amount
	store result
	jmp loop_end
 
is_flag_1:
	load neg_flag
	bnez neg_re
	jmp loop_end
 
is_neg:
    load error_mask
    store result
	jmp loop_end

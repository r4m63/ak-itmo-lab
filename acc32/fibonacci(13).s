.data
input_addr:      .word  0x80
output_addr:     .word  0x84
n:               .word  0x00
current:         .word  0x00              
previous:		 .word  0x00
tmp_current:     .word  0x00
constant_1:      .word  0x01
 
.text
_start:
	load_ind	 input_addr
    store        n
 
check:
	ble			 not_in_domain
	beqz         fibonacci_end
	load_imm     0x01
	store        current
 
calculating_loop:
    load         n
	sub 		 constant_1
	store        n
 
	beqz		 fibonacci_end
	load		 current
	store        tmp_current
	add 		 previous
 
    bvs          overflow_value
 
	store		 current
	load 		 tmp_current
	store        previous
 
	jmp          calculating_loop
 
fibonacci_end:
	load         current
	store_ind    output_addr               
    halt
 
overflow_value:
	load_imm     0xCCCCCCCC
    store_ind    output_addr
    halt
 
not_in_domain:
    load_imm     -1
    store_ind    output_addr                 
    halt

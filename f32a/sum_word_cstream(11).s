	.data
low_res: 	   .word 0x0
high_res:      .word 0x0
input_addr:    .word 0x80
output_addr:   .word 0x84
 
	.text
    .org 	   0x88
 
_start:
	lit 1 eam
	@p input_addr a!
 
loop:
	lit 0
	@
	check_number
 
without_check_carry:
	@p low_res
	+
	!p low_res
	loop ;
 
with_check_carry:
	@p low_res
	+
	dup
	!p low_res
	+
	@p low_res
	xor
	if 	loop
 
 
inc_high_res:
	@p high_res
	lit 1 +
	!p high_res
	loop ;
 
check_number:
	dup
	if write_output
	dup
	-if with_check_carry
	;
 
 
write_output:
	@p output_addr a!
	@p high_res !
	@p low_res !
 
	halt

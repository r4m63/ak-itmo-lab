	.data
input_addr:    .word 0x80
output_addr:   .word 0x84
hi_part:       .word 0x0
lo_part: 	   .word 0x0
 
	.text
    .org       0x88
_start:
	@p input_addr b!
	lit 1 eam
 
while:
	lit 0			\ need to get carry flag
	@b
	dup
	if return_result
	dup
	-if with_carry_stuff \new number >= 0
	\ add with number < 0 can set carry, but we don't need to increase_hi_part 
	@p lo_part
	+
	!p lo_part
	while ;
 
with_carry_stuff:
	@p lo_part
	+
	dup				\ carry doesn't change
	!p	lo_part
	+				\ 0 + lo_part + carry
	@p	lo_part
	xor
	if	while
	increase_hi_part
    while ;
 
 
increase_hi_part:
	@p hi_part
	lit 1 +
	!p hi_part
	;
 
 
return_result:
	@p output_addr b!
	@p hi_part
	!b
	@p lo_part
	!b
 
end:
	halt

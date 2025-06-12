	.data
 
input_addr:    		.word 0x80
output_addr:   		.word 0x84
lo_part: 	   		.word 0x0
hi_part:       		.word 0x0
posive_num: 		.word 0x1
 
	.text
    .org 	   0x88
_start:
	@p input_addr b!
	lit 1 eam
 
while_cstream:
	@b
	dup
	if	sum_word_cstream_end
	dup
	-if continue
	lit 0 !p posive_num	
continue:
	upd_lo_part_and_return_carry
	@p	posive_num and
	@p	hi_part
	+
	!p	hi_part
	lit	1 !p posive_num
	while_cstream ;
 
upd_lo_part_and_return_carry:
	lit 0
	over
	@p lo_part
	+
	dup
	!p lo_part
	+
	@p lo_part
	xor
	;
 
sum_word_cstream_end:
	@p output_addr b!
	@p hi_part !b
	@p lo_part !b
	halt

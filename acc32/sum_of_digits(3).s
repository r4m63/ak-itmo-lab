.data
sum:     .word 0
input_addr:      .word 0x80 
output_addr:     .word 0x84
ten:        .word 10
one:    .word 1
tmp:    .word 0
 
 .text
_start:
 load_ind   input_addr
 
 bgt    save
 
 not    
 add    one
 
save: 
 store   tmp
 
while:
 load    tmp
 rem    ten
 add    sum 
 store   sum
 
 load    tmp
 div    ten
 store   tmp
 
 bnez   while
 
 load   sum
 store_ind  output_addr
 
 halt

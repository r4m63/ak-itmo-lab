.data
 
input_addr:      .word  0x80
output_addr:     .word  0x84        
 
 
.text
 
_start:
 
    lit 0
    @p output_addr b!       \put output addr to reg b
    @p input_addr  a! @     \put input val on top of data stack
 
 
	count_ones                  \call count function
 
	!b                          \print result
 
	halt	
 
count_ones:
 
	lit 31 >r                   \put len counter to return stack for next operator
 
	while:
 
        dup lit 0x1 and         \get the first bit of number
		if skip                 \if zero - skip inc
 
		over lit 1 + over       \swap number and counter, inc, swap again
 
        skip:
		    2/                  \ >>
 
		next while 
 
	drop ;

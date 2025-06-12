    .data
 
input_a_b:       .word  0x80               ; Input address where the number a
a:	 	         .word  0x00               ; Variable to store the a_input, initialized to 0
b:	 	         .word  0x00               ; Variable to store the b_input, initialized to 0
result:		     .word  0x00               ; Variable to store the b, initialized to 0
output_addr:     .word  0x84               ; Output address where the result should be stored
 
    .text
 
_start:    
    load_ind     input_a_b                 ; acc = mem[mem[input_a_b]]   
    store        a                    	   ; mem[a]= acc
    load_ind     input_a_b                 ; acc = mem[mem[input_a_b]]   
    store        b                         ; mem[b]= acc
 
loop:
    load     	 b                   	   ; acc = mem[b]   
    beqz         gcd_end                   ; if (acc == 0) goto gcd_end 
    store        result                    ; mem[result]= acc     
    load     	 a		   	               ; acc = mem[a]  
    rem 	     b			               ; acc = acc % mem[b]
    store        b                         ; mem[b]= acc
    load         result 	               ; acc = mem[result]  
    store        a                         ; mem[a]= acc
    jmp          loop             	       ; goto loop
 
gcd_end:
 
    load         a                    	   ; acc = mem[a]
    store_ind    output_addr               ; mem[mem[output_addr]] = acc
    halt

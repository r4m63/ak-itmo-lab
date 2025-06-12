.data
input_addr:     .word 0x80        
output_addr:    .word 0x84        
 
number:         .word 0           
one:            .word 1           
two:            .word 2           
neg_one:        .word -1          
zero:           .word 0
three:          .word 3           
 
i:              .word 0                     
 
.org 0x100
.text
 
_start:
    load_ind input_addr
    store number
 
    load number
    beqz input_error
 
    ble input_error
 
    sub one
    beqz return_not_prime
 
    sub one
    beqz return_prime
 
    load number
    rem two
    beqz return_not_prime
 
    load three
    store i
 
loop:
    load number
    div i
    sub i
    ble return_prime
 
    load number
    rem i
    beqz return_not_prime
 
    load i
    add two
    store i
 
    jmp loop
 
return_prime:
    load one
    jmp exit
 
return_not_prime:
    load zero
    jmp exit
 
input_error:
    load neg_one
    jmp exit
 
exit:
    store_ind output_addr
    halt

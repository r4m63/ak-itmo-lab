    .data
divider:         .word  0x02
input:           .word  0x80
output:          .word  0x84
init:            .word  0x00
counter:         .word  0x02
one:             .word  0x01
 
 
    .text
    .org         0x100
_start:
    ; Loading a number, saving, calculating stop criteria
    load_ind     input
    store_addr   init
    div          divider
    sub          one
    beqz         prime
 
    load_addr    init
    ; Checking if number is greater than 1
    sub          one
    beqz         not_prime
    ble          error
 
 
loop:
    load_addr    init
    rem          counter
    beqz         not_prime
 
    load_addr    counter
    mul          counter
    sub          init
    bgt          prime
    load_addr    counter
    add          one
    store_addr   counter
 
    jmp          loop
 
 
 
not_prime:
    load_addr    one
    sub          one
    store_ind    output
    halt
 
prime:
    load_addr    one
    store_ind    output
 
 
    halt
 
error:
    load_addr    one
    sub          one
    sub          one
    store_ind    output
 
    halt

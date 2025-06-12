    .data
input_addr: .word  0x80
output_addr: .word  0x84
 
iter: .word 2
square_root: .word 0x00
input: .word 0x00
 
 
const_fail: .word -1
const_false: .word 0x00
const_1: .word 0x01
const_2: .word 2
const_3: .word 0x03
 
sqrt_iter: .word 10
    .text
 
.org 150
_start:
    load_ind input_addr
    sub const_1
    ble return_fail
    beqz return_false
    add const_1
    store_addr input
    store_addr square_root
sqrt:
    load_addr input
    div square_root
    add square_root
    div const_2
    store_addr square_root
    load_addr sqrt_iter
    sub const_2
    ble check_even
    add const_1
    store_addr sqrt_iter
    jmp sqrt
check_even:
    load_addr input
    rem iter
    beqz loop
    load_addr iter
    add const_1
    store_addr iter
loop:
    load_addr input
    rem iter
    beqz return_false
    load_addr iter
    add const_2
    sub square_root
    bgt return_true
    add square_root
    store_addr iter
    jmp loop
return_fail:
    load_addr const_fail
    jmp end 
return_false:
    load_addr const_false
    jmp end
return_true:
    load_addr const_1
end:
    store_ind output_addr
    halt

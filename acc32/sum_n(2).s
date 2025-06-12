.data
 
input_addr: .word 0x80
output_addr: .word 0x84
n: .word 0x00
sum: .word 0x00
counter: .word 0x01
two: .word 0x02
 
.text
 
_start:
    load_ind input_addr
    store n
    ble not_in_domain
    beqz not_in_domain
 
calc:
    load sum
    add n
    add counter
    mul n
    bvs overflow
    div two
    store sum
    jmp end
 
not_in_domain:
    load_imm     -1
    store_ind    output_addr
    halt
 
overflow:
    load_imm     0xCCCC_CCCC
    store_ind    output_addr
    halt
 
end:
    load sum
    store_ind output_addr
    halt

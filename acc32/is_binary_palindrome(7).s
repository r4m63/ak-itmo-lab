.data
input_addr:  .word  0x80
output_addr: .word  0x84
 
input:       .word 0x0
copy:        .word 0x0
one:         .word 0x1
zero:        .word 0x0
min_one:     .word -1
rev:         .word 0x0
iter:        .word 0x20
 
.text
.org 150
_start:
    load_ind input_addr
    store_addr input ; вот этот я буду сравнивать 
    store_addr copy ; а вот это постоянно проверяю
 
    load_addr zero
    store_addr rev ; с вот этим
 
loop:
    ; если все итерации прошли, можем идти проверятся 
    load_addr iter
    beqz check
 
    ; сейчас своруем бит и сдвинем вправо copy 
    ; потом засунем его в rev и сдвинем его вправо
 
    load_addr rev
    shiftl one
    store_addr rev
 
    load_addr copy
    and one
    add rev
    store_addr rev
 
    load_addr copy
    shiftr one
    store_addr copy
 
    ; iter--
    load_addr iter
    sub one
    store_addr iter
 
    jmp loop
 
 
check:
    load_addr input
    sub rev
    beqz return_true
 
return_false:
    load_addr zero
    jmp end
 
return_true:
    load_addr one
 
end:
    store_ind output_addr
    halt

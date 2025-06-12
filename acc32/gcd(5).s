.data
input_addr: .word   0x80
output_addr: .word  0x84
a:  .word   0x00
b:  .word   0x00
temp: .word 0x00
ONE_CONST: .word 0x01
 
.text
_start:
 
    load_ind    input_addr
    store  a
 
    load_ind    input_addr
    store  b
 
    loop:
        load b
        beqz end_loop
 
        load a
        rem b
        store temp
 
        load b
        store a
 
        load temp
        store b
        jmp loop
    end_loop:
        load a
        bgt end
        not
        add ONE_CONST
    end:
        store_ind output_addr
    halt

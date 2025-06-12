    .data
in_addr:  .word 0x80
a:        .word 0
b:        .word 0 
tmp:      .word 0
out_addr: .word 0x84
 
    .text
_start:
    load_ind  in_addr
    store a
    load_ind  in_addr  
    store b
 
loop:
    load b
    beqz end
    store tmp
    load a
    rem  b                
    store b
    load tmp
    store a
    jmp loop
 
end:
    load a
    store_ind out_addr
    halt

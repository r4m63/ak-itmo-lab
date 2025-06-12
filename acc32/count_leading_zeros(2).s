    .data
 
    input_addr:      .word  0x80
    output_addr:     .word  0x84
 
    n:               .word  0x00
    count:           .word  0x00
    mask:            .word  0x80000000
    const_0:         .word  0x00
    const_1:         .word  0x01
    const_32:        .word  0x20
 
    .text
 
    _start:
        load_ind     input_addr
        store        n
        beqz         input_zero             
 
        load         const_0
        store        count
 
    loop:
        load         n
        and          mask                   
        bnez         done                   
 
        load         n
        shiftl       const_1                
        store        n
 
        load         count
        add          const_1
        store        count
 
        jmp          loop
 
    done:
        load         count
        store_ind    output_addr
        halt
 
    input_zero:
        load         const_32
        store_ind    output_addr
        halt

.data
 
input_addr:     .word   0x80
output_addr:    .word   0x84
count:          .word   0x00
one:            .word   0x01
mask:           .word   0x80000000
n:              .word   0x00
 
.text
.org 0x90
_start:
        @p input_addr a! @
        dup
        !p n
        if zero
 
 
loop:
        @p n
        @p mask
        and
        if inc
        @p count
        @p output_addr a! !
        halt
 
inc:
        @p count
        @p one
        +
        !p count
        @p mask
        2/
        !p mask
        loop
 
 
zero:
        lit 0x20
        @p output_addr a! !
        halt

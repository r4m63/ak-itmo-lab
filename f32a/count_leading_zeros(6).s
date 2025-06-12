    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
result_addr:     .word 0x90
 
    .text
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
_start:
    @p input_addr a! @       \ {n}
 
    count
 
    @p output_addr a! !
    halt
 
    \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 
count:
    inv
    @p result_addr b!           \ mem[b] = result
    lit 0x80000000 a!           \ store mask 0x1000000... in a
 
count_cycle:
    dup                     \ {n, n}
    a                       \ {n, n, a}
    and                     \ {n, n & a}
    if end                  \ {n}; if n & a == 0: break
    lit 1                   \ {n, 1}
    @b                      \ {n, 1, result}
    +                       \ {n, result + 1}
    !b                      \ {n}; mem[b] = result
    a                       \ {n, a}
    2/                      \ {n, a >> 1}; after first iter a = 0x1100...
    lit 0x7FFFFFFF          \ {n, a >> 1, 0x0111...}; so we have to remove the leading 1
    and                     \ {n, a >> 1}; not there is no leading 1
    a!                      \ {n}; a >>= 1
    count_cycle ;
 
end:
    @b                      \ {n, result}
    ;                       \ return

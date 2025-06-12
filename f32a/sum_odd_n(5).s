.data
 
input_addr:      .word  0x80
output_addr:     .word  0x84	 
 
.text
 
_start:
    @p input_addr a! @       \ n:[]
 
    solution
 
    @p output_addr a! !
    halt
 
 
multiply:
    lit 31 >r                \ for R = 31
multiply_do:
    +*                       \ mres-high:acc-old:n:[]; mres-low in a
    next multiply_do
    drop drop a              \ mres-low:n:[] => acc:n:[]
    ;
 
 
\((n + 1) / 2) ^ 2
solution:
    dup
    -if formula
    err_fininish
    ;
formula:
    dup
    if err_fininish
    lit 1 +                 \ n + 1:[]
    2/                      \ n/2:[]
    dup
    lit -46341 +
    -if overflow
	dup
    a!
    lit 0                   \ 0:n:[]
    multiply
    ;
 
overflow:
    lit -858993460
	;
 
err_fininish:
    lit -1
    ;

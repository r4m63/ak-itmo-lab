     \ сумма нечетных чисел от 1 до n
     \ если n <= 0 то вернуть -1
     \ если результат > 2^31-1 то вернуть 0xCC_CC_CC_CC
     \ формула: S = k^2, k = [(n+1) / 2]
     \ k^2 <= 2^31-1
     \ k <= 46340
     \ n <= 92680 (0xCC_CC_CC_CC)
 
 
    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
 
    .text
_start:
 
    @p input_addr a! @       \ n:[]
 
    sum_odd_n
 
    @p output_addr a! !      \ сохранить результат \ n:[]
 
    halt
 
    \ в регистре А находится n и
    \ T = n
sum_odd_n:
 \ n:[]
    dup                      \ n:n:[]
    if not_positive          \ if n == 0 -> not_positive \ n:[]
    dup                      \ n:n:[]
    -if check_overflow       \ if n >=0 -> check_overflow \ n:[]
    not_positive ;           \ if n < 0 ->jump to not_positive
 
    \ n:[]
check_overflow:
    dup                      \ n:n:[]
    lit 92681                \ 92681:n:n:[]
    inv                      \ ~92681:n:n:[]
    + lit 1 +                \ (n - 92681):n:[]
    -if overflow             \ n:[]
    compute_sum ;
 
    \ n:[]
compute_sum:
    \ compute k
    lit 1 + 2/               \ (n+1)/2:[]   \ k:[]
    \ return k^2
    square                   \ call square  \ k^2:k:[]
    ;
 
    \ k:[]
square:
    dup a!                   \ k:[]; k -> A
    lit 0                    \ 0:k:[]
    lit 31 >r                \ for R = 31
 
multiply_do:
    +*                       \ mres-high:k-old:[]; mres-low in a
    next multiply_do
 
    \ k^2:k:[]
    drop drop a              \ mres-low:n:[] => acc:n:[]
    ;
 
not_positive:
 \ n:[]
    lit -1
    ;
 
overflow:
    lit 0xCCCCCCCC
    ;

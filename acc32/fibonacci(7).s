    .data
 
input_addr:      .word  0x80
output_addr:     .word  0x84
n:               .word  0x00
a:               .word  0x00               ;  F(n - 2)
b:               .word  0x00               ;  F(n - 1)
i:               .word  0x00               ;  Counter
tmp:             .word  0x00               ;  F(n)
zero:            .word  0x00               ;  0
const_1:         .word  0x01               ;  1
const_2:         .word  0x02               ;  2
minus_1:         .word  -1                 ;  -1
overflow_val:    .word  0xCCCC_CCCC
 
    .text
    .org         0x100
 
_start:
 
    clv
    load_ind     input_addr                  ; acc = mem[mem[input_addr]]
    store        n                           ; n <- acc
 
 
 
    beqz         end                         ; if n == 0 -> return 0
 
    ble          not_in_domain
 
    sub          const_1                     ; acc = n - 1
    beqz         ret_one                     ; if n == 1 -> return 1
 
 
 
 
init:
    load         zero
    store        a                           ; a = 0
    load         const_1
    store        b                           ; b = 1
    load         const_2
    store        i                           ; i = 2
 
fib_loop:
    load         i
    sub          n
    bgt          fib_done                    ; if i > n -> break
 
    load         a
    add          b                           ; acc = a + b
    bvs          over                        ; if overflow -> error
    store        tmp                         ; tmp = a + b
 
    load         b
    store        a                           ; a = b
 
    load         tmp
    store        b                           ; b = tmp
 
    load         i
    add          const_1
    store        i                           ; i++
 
    jmp          fib_loop                    ; repeat
 
fib_done:
    load         b                           ; acc = F(n)
    jmp          end
 
 
ret_one:
    load         const_1                     ; acc = 1
    jmp          end
 
not_in_domain:
    load         minus_1                     ; acc = -1
    jmp          end
 
over:
    load         overflow_val                ; acc = 0xCCCC_CCCC
 
end:
    store_ind    output_addr                 ; mem[mem[output_addr]] = acc
    halt

 
 
 
    .data
.org             0x00
buffer:          .byte  '________________________________'
 
.org             0x100
 
input_addr:      .word  0x80               \ Input address
output_addr:     .word  0x84               \ Output address
buffer_addr:     .word  0x00               \ Buffer address
buffer_size:     .word  32                 \ Size of the buffer
zero:            .word  0                  \ End of the c-string
neg_10:          .word  -10                \ Diff between ascii \n and 0
neg_97:          .word  -97                \ Diff between ascii a and 0
neg_32:          .word  -32                \ Diff between lower and upper case
const_overflow:  .word  0xCCCCCCCC         \ Constant for overflowing
 
 
 
    .text
    .org 0x200
_start:
    @p output_addr b!        \ b <- mem[output_addr]
    @p buffer_addr a!        \ a <- mem[buffer_addr]
    @p buffer_size
    lit -1 +
    >r
 
iteration:
    @p 0x80                  \ dataStack.push(mem[input_addr])
 
    is_string_end            \ is_string_end( T )
    if string_end
 
    to_upper_case            \ to_upper_case( T )
 
    write_to_buffer          \ write_to_buffer( T )
 
    next iteration
 
overflow:
    @p const_overflow
    !b                       \ std::out << const_overflow
    halt
 
 
\ void is_string_end( char )
is_string_end:
    dup
    @p neg_10 +
    if string_ended            \ if(T == 10) goto string_ended
 
    lit -1
    _end ;
 
string_ended:
    lit 0
 
_end:
    ;
 
 
 
\ char to_upper_case( char )
to_upper_case:               
    dup
    @p neg_97 +
    inv
    -if to_upper_case_end    \ if(T < 97) return
    @p neg_32 +              
to_upper_case_end:
    ;
 
 
 
\ void write_to_buffer( char )
write_to_buffer:             
    @
    lit 0xffffff00 and +
    !+
    ;                        \ return
 
 
 
\ void string_end( T )
string_end:
    @p zero
    write_to_buffer
 
    @p buffer_addr a!        \ a <- mem[buffer_addr]
 
write_to_output:
    @+
    lit 0x000000ff and
    dup
    if stop
    !b
    write_to_output ;
 
stop:
    halt

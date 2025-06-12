.data
buffer: .byte '_____________________________________'
input_addr: .word 0x80
output_addr: .word 0x84
buffer_size: .word 0x20
into_word: .byte '\0___'
nill: .word 0x00
dash: .byte 0x5f
byte_mask: .word 0x00FF
error_overflow: .word 0xCCCC_CCCC
.text
.org 0x90
to_uppercase:
dup
lit 'a' inv lit 1 + +
-if next
;
next:
dup
lit 'z' inv +
-if to_uppercase_end
lit 'a' inv lit 1 + +
lit 'A' +
to_uppercase_end:
;
read_line:
@p input_addr
b!
lit 0
lit buffer
a!
read_loop:
dup
lit 0x20 inv lit 1 + +
-if overflow_case
@b
dup
@p byte_mask and
lit 10 inv lit 1 + +
if ending
to_uppercase
@p into_word +
!+
lit 1 +
read_loop
;
ending:
drop
lit 0x5f5f5f00
!
lit 1 +
@p buffer_size
lit buffer
@p byte_mask and
a!
;
print:
@p output_addr b!
lit buffer
a!
print_loop:
over
lit -1 +
dup
if print_end
over
@+
@p byte_mask and
dup
if print_end
!b
lit -1 +
print_loop
print_end:
;
overflow_case:
@p output_addr a!
@p error_overflow !
halt
_start:
read_line
print
halt

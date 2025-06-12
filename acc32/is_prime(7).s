.data
input_addr: .word 0x80
output_addr: .word 0x84
num: .word 0
const_one: .word 1
const_two: .word 2
const_minus_one: .word -1
const_zero: .word 0
quotient: .word 1
mean: .word 0
divisor: .word 2
.text
.org 0x88
_start:
load_ind input_addr
store num
store mean
sub const_one
beqz not_prime
ble write_minus_one
calculate_sqrt:
load quotient
sub mean
beqz while
bgt while
load mean
add quotient
shiftr const_one
store mean
load num
div mean
store quotient
jmp calculate_sqrt
while:
load divisor
sub mean
bgt prime
load num
rem divisor
beqz not_prime
load divisor
add const_one
store divisor
jmp while
write_minus_one:
load const_minus_one
jmp return_result
prime:
load const_one
jmp return_result
not_prime:
load const_zero
jmp return_result
return_result:
store_ind output_addr
halt

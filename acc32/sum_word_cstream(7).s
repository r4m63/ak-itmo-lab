    .data
input_addr:      	.word  0x80
output_addr:     	.word  0x84
low:             	.word  0x00
high:            	.word  0x00
temp:            	.word  0x00
const_1:         	.word  0x01
const_minus_one: 	.word  -1
    .text
 
_start:
 
while:
    load_ind     input_addr
    beqz         end
    store        temp
    add          low
    store        low
    bcc          high_input
    load         const_1
    add          high
    store        high
high_input:
    load         temp
    bgt          while
    load         const_minus_one
    add          high
    store        high
    jmp          while
end:
    load         high
    store_ind    output_addr
    load         low
    store_ind    output_addr
    halt

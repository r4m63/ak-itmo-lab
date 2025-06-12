    .data

buf:                .byte   '________________________________'
buf_start:          .word   0x0
i:                  .word   0x0
ptr:                .word   0x0
intput_addr:        .word   0x80
output_addr:        .word   0x84
buf_size:           .word   0x20
eof:                .word   0xA
cap_case_shift:     .word   32
space:              .word   0x20
const_a:            .word   'a'
const_z:            .word   'z'
const_A:            .word   'A'
const_Z:            .word   'Z'
const_1:            .word   1
const_0:            .word   0
const_FF:           .word   0xFF
mask:               .word   0xFFFFFF00
overflow_value:     .word   0xCCCC_CCCC
cap_flag:           .word   1
tmp:                .word   0x0

    .text

_start:
    load_addr       buf_start
    add             const_1
    store_addr      ptr
    load_addr       const_0
    store_addr      i

read_cycle:
    sub             buf_size
    beqz            overflow
    load_ind        intput_addr
    and             const_FF
    store_addr      tmp
    load_addr       eof
    sub             tmp
    beqz            store_str_len
    load_addr       space
    sub             tmp
    beqz            set_cap_flag
    load_addr       cap_flag
    beqz            to_lowercase

to_uppercase:                                   
    load_addr       tmp
    sub             const_a                     
    ble             remove_cap_flag
    load_addr       const_z
    sub             tmp
    ble             remove_cap_flag
    load_addr       tmp
    sub             cap_case_shift
    store_addr      tmp

remove_cap_flag:
    load_addr       const_0
    store_addr      cap_flag
    jmp             store_tmp

to_lowercase:
    load_addr       tmp
    sub             const_A                     
    ble             store_tmp
    load_addr       const_Z
    sub             tmp
    ble             store_tmp
    load_addr       tmp
    add             cap_case_shift
    store_addr      tmp
    jmp             store_tmp

set_cap_flag:
    load_addr       const_1
    store_addr      cap_flag

store_tmp:
    load_ind        ptr
    and             mask
    or              tmp
    store_ind       ptr
    load_addr       ptr
    add             const_1
    store_addr      ptr
    load_addr       i
    add             const_1
    store_addr      i
    jmp             read_cycle

store_str_len:
    load_ind        buf_start
    and             mask
    or              i
    store_ind       buf_start
    load_addr       buf_start
    add             const_1
    store_addr      ptr    
    load_addr       i

print_cycle:
    beqz            end
    load_ind        ptr
    and             const_FF
    store_ind       output_addr
    load_addr       ptr
    add             const_1
    store_addr      ptr
    load_addr       i
    sub             const_1                    
    store_addr      i
    jmp             print_cycle

end:
    halt

overflow:
    load_addr       overflow_value
    store_ind       output_addr
    halt

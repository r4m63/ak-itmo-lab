    .data
    .org    0x0

buffer:          .byte  '________________________________'
input_addr:      .word  0x80
output_addr:     .word  0x84

    .text
    .org     0x100

func_read_word:
    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       t0, 0x0(t0)
    lw       a0, 0x0(t0)
    jr       ra

func_write_word:
    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
    lw       t0, 0x0(t0)
    sw       a0, 0x0(t0)
    jr       ra

func_read_line_and_cvt_to_capital_case:
    addi     sp, sp, -32
    sw       ra, 28(sp)
    sw       s0, 24(sp)
    sw       s1, 20(sp)
    sw       s2, 16(sp)
    sw       s3, 12(sp)
    xor      s0, s0, s0
    mv       s1, a0
    xor      s2, s2, s2
    mv       s3, a1

read_line_and_cvt_to_capital_case_loop:
    beq      s2, s3, read_line_and_cvt_to_capital_case_end
    jal      ra, func_read_word
    lui      t0, %hi(0xA)
    addi     t0, t0, %lo(0xA)
    beq      a0, t0, read_line_and_cvt_to_capital_case_end
    lui      t0, %hi(0x20)
    addi     t0, t0, %lo(0x20)
    ble      a0, t0, read_line_and_cvt_to_capital_case_layout_character
    lui      t0, %hi(0x41)
    addi     t0, t0, %lo(0x41)
    addi     t1, t0, 0x19
    bgtu     a0, t1, read_line_and_cvt_to_capital_case_not_uppercase
    bgtu     t0, a0, read_line_and_cvt_to_capital_case_not_uppercase
    beqz     s0, read_line_and_cvt_to_capital_case_loop_next_iteration
    addi     a0, a0, 0x20
    j        read_line_and_cvt_to_capital_case_loop_next_iteration

read_line_and_cvt_to_capital_case_not_uppercase:
    lui      t0, %hi(0x61)
    addi     t0, t0, %lo(0x61)
    addi     t1, t0, 0x19
    bgtu     a0, t1, read_line_and_cvt_to_capital_case_not_lowercase
    bgtu     t0, a0, read_line_and_cvt_to_capital_case_not_lowercase
    bnez     s0, read_line_and_cvt_to_capital_case_loop_next_iteration
    addi     a0, a0, -32
    j        read_line_and_cvt_to_capital_case_loop_next_iteration

read_line_and_cvt_to_capital_case_not_lowercase:
    j        read_line_and_cvt_to_capital_case_loop_next_iteration

read_line_and_cvt_to_capital_case_layout_character:
    xor      s0, s0, s0
    j        read_line_and_cvt_to_capital_case_loop_place_and_update

read_line_and_cvt_to_capital_case_loop_next_iteration:
    xor      s0, s0, s0
    addi     s0, s0, 1

read_line_and_cvt_to_capital_case_loop_place_and_update:
    add      t0, s1, s2
    sb       a0, 0(t0)
    addi     s2, s2, 1
    j        read_line_and_cvt_to_capital_case_loop

read_line_and_cvt_to_capital_case_end:
    add      t0, s1, s2
    bne      s2, s3, read_line_and_cvt_to_capital_case_write_symbol
    addi     t0, t0, -1

read_line_and_cvt_to_capital_case_write_symbol:
    sb       zero, 0(t0)
    mv       a0, s2
    lw       s0, 24(sp)
    lw       ra, 28(sp)
    lw       s1, 20(sp)
    lw       s2, 16(sp)
    lw       s3, 12(sp)
    addi     sp, sp, 32
    jr       ra

func_print_c_string:
    addi     sp, sp, -16
    sw       ra, 12(sp)
    sw       s0, 8(sp)
    mv       s0, a0

print_c_string_loop:
    lw       a0, 0(s0)
    lui      a2, %hi(0xFF)
    addi     a2, a2, %lo(0xFF)
    and      a0, a0, a2
    beq      a0, zero, print_c_string_end
    jal      ra, func_write_word
    addi     s0, s0, 1
    j        print_c_string_loop

print_c_string_end:
    lw       ra, 12(sp)
    lw       s0, 8(sp)
    addi     sp, sp, 16
    jr       ra

_start:
    lui      sp, %hi(0x1000)
    addi     sp, sp, %lo(0x1000)
    addi     sp, sp, -16
    sw       ra, 12(sp)
    xor      a0, a0, a0
    lui      a1, %hi(0x20)
    addi     a1, a1, %lo(0x20)
    jal      ra, func_read_line_and_cvt_to_capital_case
    lui      t0, %hi(0x20)
    addi     t0, t0, %lo(0x20)
    beq      a0, t0, overflowed
    xor      a0, a0, a0
    jal      ra, func_print_c_string
    j        end_calls

overflowed:
    lui      a0, %hi(0xCCCCCCCC)
    addi     a0, a0, %lo(0xCCCCCCCC)
    jal      ra, func_write_word

end_calls:
    lw       ra, 12(sp)
    addi     sp, sp, 16

    halt

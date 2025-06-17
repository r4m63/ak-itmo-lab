    .data
input_addr:     .word  0x80
output_addr:    .word  0x84
stack_top:      .word  0x7C

    .text
_start:
    movea.l     stack_top, A7
    movea.l     (A7), A7                ; A7 = stack_top

    movea.l     input_addr, A1
    movea.l     (A1)+, A0               ; A0 = input_addr
    movea.l     (A1), A1                ; A1 = output_addr

    move.l      0, D2                   ; D2 - high_part = 0
    move.l      0, D3                   ; D3 - low_part = 0

    move.l      (A0), D0                ; D0 = counter (num_of_words)

loop:
    jsr         read_and_sum_one_word
    sub.l       1, D0                   ; counter--
    bne         loop                    ; if counter == 0 then break

end:
    move.l      D2, (A1)
    move.l      D3, (A1)                ; save result parts to output

    halt


read_and_sum_one_word:
    move.l      (A0), D1                ; D1 = cur_readed_word
    bpl         positive

negative:
    jsr         sub_step
    rts

positive:
    jsr         add_step
    rts


    .text
    .org 0x88
add_step:
    move.b      1, D4

    add.l       D1, D3                  ; low_part += cur_readed_word
    bcc         end_of_add
    add.l       D4, D2                  ; high_part (+=) C

end_of_add:
    rts


sub_step:
    move.l      -1, D4

    not.l       D1
    add.l       1, D1

    cmp.l       D2, D1

    bcs         sub_operation
    move.l      0, D4

sub_operation:
    sub.l       D1, D3                  ; low_part -= |cur_readed_word|
    add.l       D4, D2                  ; high_part (-=) C

end_of_sub:
    rts
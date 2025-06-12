.data
in_ptr:     .word  0x80
out_ptr:    .word  0x84
 
.text
_start:
    @p in_ptr
    b!
    @b
    >r
 
    lit 0 lit 0
    next loop_body
 
loop_body:
    lit 0 over
    @b
    dup -if needs_eam
no_needs_eam:
    lit 0 eam
	end_loop ;
needs_eam:
    lit 1 eam
end_loop:
	add_parts
	next loop_body
 
finalize:
    @p out_ptr
    a!
    over
    ! !
    halt
 
add_parts:
    +           \ lo + num
    a!          \ сохранить в A
    +           \ hi + carry
    a           \ восстановить lo
    ;

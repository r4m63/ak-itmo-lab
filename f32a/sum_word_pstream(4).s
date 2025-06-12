.text
 
_start:
        lit 0x80 
        b!
 
        lit 0 
        lit 0 
 
        @b 
        dup
        if done  
        >r  
        next loop
loop:
        @b 
        dup
        -if el_positive
        lit 0 
el_return:
        eam
        + 
        dup
        dup
        +
        lit 1
        and
        a!
        over
        a
        +
        over
        next loop 
done:
        lit 0x84
        a!
        over 
        ! 
        ! 
        halt  
el_positive:
        lit 1
        lit 0 if el_return

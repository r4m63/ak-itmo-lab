.text
 
_start:
        lit 0x80 
        b!
 
        lit 0 
        lit 0 
 
        @b 
        dup
        if finish  
        >r  
        next cycle
cycle:
        @b 
        dup
        -if positive_case
        lit 0 
return_point:
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
        next cycle 
finish:
        lit 0x84
        a!
        over
        ! 
        ! 
        halt  
positive_case:
        lit 1
        lit 0 if return_point

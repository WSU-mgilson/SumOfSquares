;Write useful comments so you can actually use this on the exams and know what it does

;Looking at Max C code, we havve two functions/sub routines. 
;Square function is the base of my program, and SOS builds off of it.

;Square function needs to take in 1 arg and multiply the number passed to it by itself
    ;So I feel I need like 3 registers for this function, an accumulator which is where I store the answer
    ;A count register to hold the loop count 
    ;Finally the act
.ORIG  x3000

;int main()
;return address
LD R6, STACK_BOTTOM ; R6 = x6000
;Note if I get an exam question, push happens in 3 parts
;Get the value I want into a register, in this case my ARRAY_SIZE
;Move the stack pointer(R6) down, aka reserve a space
;Then store the register into that reserve space
LD R1, ARRAY_SIZE
ADD R6, R6, #-1
STR R1, R6, #0 ;R1 now has my array size of 5 in it

;Same principles, just changing the tools
LEA R2, ARRAY
ADD R6, R6, #-1
STR R2, R6, #0 ; R2 now has my array in it
JSR SumOfSquares

LDR R0, R6, #0
ADD R6, R6, #1
ADD R6, R6, #1
ADD R6, R6, #1

ADD R6, R6, #-1 
STR R0, R6, #0

;Now read the values by popping of the stack, remember LIFO, so I need to pop in reverse order



HALT

;;Return register = R0
;;General Purpose Registers = R1-R3
;;R5 = Frame pointer(bottom of the Stack pointer)
;;R6 = stack pointer, top of the stack or current location pointer
;;R7 = return address
SQUARE_NUM
    ;doing -2, but it reserves two spots for my return address and my return value from my loop
    ADD R6, R6, #-1 ;This is where my Return value will be stored
    ADD R6, R6, #-1 ;This is where R7 will be stored at
    ;Store R6 into my return register R7
    STR R7, R6, #0

    ;this is where I will be storing my frame pointer
    ADD R6, R6, #-1 ;if Im doing this right
    STR R5, R6, #0
    ;So I need to reserve a spot for my local calculation
    ADD R5, R6, #-1
    ADD R6, R6, #-1

    ;Multiplication loop
        ;I need a copy value that I can add to the arg passed(doesnt change)
        ;I need an accumulator that holds the value after each iteration
        ;I need a copy value counter that also holds the value of the arg passed but decrements(does change)

    ;R1 = copied arg value(doesnt change)
    ;R2 = counter(does change)
    ;R3 = accumulator
    
    ;Copt value which is in R5
    ;AND R1, R1, #0
    ;I need to dereference R5, but add 4 to
    LDR R1, R5, #4 ;Now R1 = x or num to Square
    LDR R2, R5, #4 ;Now R2 is set X, which is my mutable cout var
    AND R3, R3, #0 ;Clear out accumulator

    ;Since we are decrementing my branch case will be while the count var is positive 
    MULTI_START
        ADD R3, R3, R1
        ADD R2, R2, #-1
    BRp MULTI_START
    ;Store R3 at the return value
    STR R3, R5, #0 ;stores R3 into my frame pointer R5, with no offset
    STR R3, R5, #3 

    ADD R6, R5, #1
    LDR R5, R6, #0

    ;pop
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1
    RET

;Takes in an array and the array's length
;Need to reserve space for the final return value R0
;Need to reserve space for the Return Address R7
;Need to reserve space for the Frame Pointer R5
SumOfSquares
    ADD R6, R6, #-1 ;Return value
    ADD R6, R6, #-1 ; Return Address
    STR R7, R6, #0

    ADD R6, R6, #-1
    STR R5, R6, #0

    ;Reserve space for locals, I now have two, so copy from Square + 1
    ADD R5, R6, #-1
    ADD R6, R6, #-1 ;local var 1
    ADD R6, R6, #-1 ; local var 2

    AND R1, R1, #0
    STR R1, R5, #0 ;Sum = 0
    STR R1, R5, #-1  ;counter & index = 0 
    
    ;call square function on the current element
    ;add result from square function to Sum Variable
    ;Increment I and Count Variable
    ;Branch if positive, need to check my other loops because I mix this up all the time for the order, bc it backwards

    ITERATE_ARRAY
        LDR R2, R5, #4 ;Sum
        LDR R3, R5, #-1 ;index and count
        ADD R2, R2, R3
        LDR, R2, R2, #0 ; read current value in R2, on pass 1 =2
        ADD R6, R6, #-1
        STR R2, R6, #0
        JSR SQUARE_NUM
        LDR R2, R6, #0
        ADD R6, R6, #1
        ADD R6, R6, #1
        LDR R3, R5, #0
        ADD R3, R3, R2
        STR R3, R5, #0

        LDR R3, R5, #-1 ;R3 is safe to use bc I already stored its value
        ADD R3, R3, #1
        STR R3, R5, #-1

        ;EXit logic
        NOT R3, R3
        ADD R3, R3, #1 ;We are now at the original number 
        LDR R2, R5, #5
        ADD R3, R3, R2
    BRp ITERATE_ARRAY

    LDR R1, R5, #0
    STR R1, R5, #3

    ADD R6, R5, #1
    LDR R5, R6, #0

    ;pop
    ADD R6, R6, #1
    LDR R7, R6, #0
    ADD R6, R6, #1 
    RET
    BRnz ITERATE_ARRAY



    

ARRAY   .FILL #2
        .FIll #3
        .FILL #5
        .FILL #0
        .FILL #1

ARRAY_SIZE .FILL #5
STACK_BOTTOM .FILL x6000
.END

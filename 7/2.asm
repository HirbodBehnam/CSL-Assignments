StSeg   Segment STACK 'STACK'
ns        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        num DW 0      ; The number to print
        num_buffer DB DUP 7 (?)
        is_complete_number DB 10,13, 'Your number is complete',10,13,'$'
        isnot_complete_number DB 10,13, 'Your number is not complete',10,13,'$'
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
        CALL READ_INPUT
        MOV AX, num
        CALL CHECK_COMPLETE_NUMBER
        MOV DX, OFFSET isnot_complete_number
        CMP AL, 0
        JZ CHECK_ALL_NUMBERS
        MOV DX, OFFSET is_complete_number 
CHECK_ALL_NUMBERS:
        MOV AH, 9 ; Print string
        INT 21H
        MOV AX, 0 ; The counter
NUMBER_LOOP:
        INC AX ; Increase the counter
        CMP AL, 0 ; Overflow happened here. So we are done
        JZ END_PROGRAM ; Done
        PUSH AX ; Make a backup
        CALL CHECK_COMPLETE_NUMBER
        POP BX ; Restore the number in BX
        CMP AL, 0
        JZ NUMBER_LOOP_CONINUE ; Nope. Not this one
        ; We should print this number
        MOV num, BX
        PUSH BX
        CALL WRITE_NUM
        POP BX
NUMBER_LOOP_CONINUE:
        MOV AX, BX ; Restore the AX
        JMP NUMBER_LOOP ; Loop
        
END_PROGRAM:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
; This function checks if a number in AL is complete or not
; The result will be returned in AL as 0 or 1
CHECK_COMPLETE_NUMBER PROC NEAR:
        MOV AH, 0 ; Unsiged extenstion
        MOV BX, 0 ; The sum goes here
        PUSH AX ; Make a backup
        MOV CX, 0 ; Make a counter for checking (We only use CL tho)
CHECK_COMPLETE_NUMBER_LOOP:
        POP AX  ; Load the number from stack
        PUSH AX ; Push back the number for next loop
        INC CX ; Increase the counter
        CMP CL, AL ; After 255, an overflow happens so we get zero
        JZ CHECK_COMPLETE_NUMBER_LOOP_DONE ; Done checking
        MOV AH, 0 ; Unsiged extenstion
        DIV CL ; Div for mod
        CMP AH, 0 ; Check factor
        JNZ CHECK_COMPLETE_NUMBER_LOOP ; Continue the loop if this is not the factor
        ; If we have reached here, we must add the CX to BX for sum
        ADD BX, CX ; We should accually use ADD BX, CL
        JMP CHECK_COMPLETE_NUMBER_LOOP ; Loop to continue
CHECK_COMPLETE_NUMBER_LOOP_DONE:        
        POP AX ; Load the main number
        ;SUB BX, AX ; Subtract the number ifself from factors
        MOV CL, 0 ; Result here (for now)
        CMP AX, BX ; Check if they are equal
        JNE CHECK_COMPLETE_NUMBER_DONE
        MOV CL, 1 ; This is ok
CHECK_COMPLETE_NUMBER_DONE:
        MOV AL, CL ; Result
        RET
CHECK_COMPLETE_NUMBER ENDP
; Print the number in num
WRITE_NUM PROC NEAR:
        MOV CX, 0 ; Count the characters of the number
        MOV AX, num
        ; At first check negative
        CMP AX, 0
        JGE WRITE_NUM_LOOP
        ; If we have reached here, we must write a (-)
        NEG AX ; So we only work with positive numbers
        PUSH AX ; Make copy
        MOV AH, 02H
        MOV DL, '-'
        INT 21H
        POP AX ; Get back the copy
WRITE_NUM_LOOP:
        MOV DX, 0 ; We are sure this is positive
        MOV BX, 10
        DIV BX
        ; Print the remainder
        ADD DL, '0' ; Convert to char
        LEA BX, num_buffer ; Load the address
        MOV SI, CX
        MOV BYTE PTR[BX+SI], DL ; Save the buffer
        INC CX ; Increase counter
        ; Check the end
        CMP AX, 0
        JNZ WRITE_NUM_LOOP ; We are not done!
WRITE_BUFFER_LOOP:
        DEC CX ; Point to last char
        LEA BX, num_buffer ; Load the address
        MOV SI, CX 
        MOV DL, [BX+SI] ; Move the char to DL
        MOV AH, 02H
        INT 21H ; Print that char
        CMP CX, 0
        JNZ WRITE_BUFFER_LOOP ; Loop to print more rest of chars
        ; Done
        MOV AH, 02H
        MOV DL, ' '
        INT 21H
        RET
WRITE_NUM ENDP
READ_INPUT PROC NEAR
READ_INPUT_LOOP:
        MOV AH, 01H
        INT 21H ; Read one char
        CMP AL, 0DH ; Check new line (the end); 0D in ascii = \r
        JE READ_INPUT_DONE ; The end
        ; Add the char to number
        SUB AL, 48 ; Convert char to number
        MOV BL, AL ; Save the digit
        MOV AX, num ; Move num to register
        MOV DX, 10 ; Set DX to 10 for mult
        MUL DX ; AX *= 10
        MOV BH, 0 ; We can avoid sign extened because this number is positive and between [0-9]
        ADD AX, BX ; Add to number
        MOV num, AX ; Save the num
        JMP READ_INPUT_LOOP
READ_INPUT_DONE:        
        RET
READ_INPUT ENDP
CDSeg   ENDS
END Start
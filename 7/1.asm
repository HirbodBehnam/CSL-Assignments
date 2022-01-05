StSeg   Segment STACK 'STACK'
ns        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        num DW 0      ; We read number here
        negative DB 0 ; Is the number negative?
        num_buffer DB DUP 7 (?)
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
        CALL READ_INPUT
        MOV AH, 02H
        MOV DL, 0AH ; Print new line
        INT 21H
        CALL WRITE_NUM
        

        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
READ_INPUT PROC NEAR
READ_INPUT_LOOP:
        MOV AH, 01H
        INT 21H ; Read one char
        CMP AL, 0DH ; Check new line (the end); 0D in ascii = \r
        JE READ_INPUT_DONE ; The end
        ; Check negative number
        CMP AL, '-'
        JE READ_INPUT_SET_NEGATIVE
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
READ_INPUT_SET_NEGATIVE:
        MOV negative, 1 ; Set negative
        JMP READ_INPUT_LOOP ; Loop to read next char
READ_INPUT_DONE:        
        ; If the number is 0 just return
        CMP negative, 0
        JZ READ_INPUT_RETURN           
        ; Otherwise negate
        NEG num
READ_INPUT_RETURN:
        RET
READ_INPUT ENDP
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
        RET
WRITE_NUM ENDP
CDSeg   ENDS
END Start

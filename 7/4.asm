StSeg   Segment STACK 'STACK'
ns        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        shown_alphabet DB 26 DUP (0)
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
READ_CHAR_LOOP:
        MOV AH, 01H
        INT 21H
        CMP AL, 0DH ; Check new line (the end); 0D in ascii = \r
        JE READ_CHAR_DONE
        OR AL, 20H ; Lowercase the char
        CMP AL, 'a'
        JL READ_CHAR_LOOP ; Non alphabet char
        CMP AL, 'z'
        JG READ_CHAR_LOOP ; Non alphabet char
        SUB AL, 'a'
        LEA SI, shown_alphabet ; Load the address here
        MOV BL, AL
        MOV BH, 0
        MOV AL, [BX][SI]+0 ; Load the seen counter
        INC AL ; Increase it
        MOV [BX][SI]+0, AL ; Save it
        JMP READ_CHAR_LOOP ; Read one one char
        
READ_CHAR_DONE:
        MOV DL, 10 ; New line
        MOV AL, 0
        MOV AH, 2
        INT 21H ; Pirnt
        LEA SI, shown_alphabet
        DEC SI ; Dec so the inc in the next loop doesn't have any effect
        MOV CX, 0 ; Simple counter

CHECK_CHAR_LOOP:
        INC SI 
        MOV AL, [SI] ; Load the byte
        CMP AL, 1 ; Check one
        JNZ CHECK_CHAR_CONITNUE ; On not zero, continue the loop
        MOV DL, CL ; Move the counter to CL
        ADD DL, 'a' ; Set to that char
        MOV AL, 0
        MOV AH, 2
        INT 21H ; Pirnt
        
CHECK_CHAR_CONITNUE:
        INC CX
        CMP CX, 28
        JNE CHECK_CHAR_LOOP ; Check loop end                
        

        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start

StSeg   Segment STACK 'STACK'
ns        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        input_filename DB 'in.txt', 0
        output_filename DB 'out.txt', 0
        input_file_handle DW ?
        output_file_handle DW ?
        buffer DB ?
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
        ; Open the input file
        MOV AL, 0 ; read
        LEA DX, input_filename
        MOV AH, 3DH
	    INT 21H
	    MOV input_file_handle, AX ; Save the handler
	    ; Open the output file
	    MOV AL, 1 ; read
        LEA DX, output_filename
        MOV AH, 3dH
	    INT 21H
	    MOV output_file_handle, AX ; Save the handler
	    
READ_LOOP: ; Read from file
        MOV BX, input_file_handle
        MOV CX, 1 ; Read one byte
        LEA DX, buffer
        MOV AH, 3FH
        INT 21H ; Read one byte
        CMP AX, 0
        JZ END_PROGRAM ; End the program at the last byte
        MOV AL, buffer        
        CMP AL, '/'
        JNE WRITE_TO_FILE ; If the char is not / just write it
        ; Otherwise change buffer with ' '
        MOV buffer, ' '
WRITE_TO_FILE:
        MOV BX, output_file_handle
        MOV CX, 1 ; Write one byte
        LEA DX, buffer
        MOV AH, 40H
        INT 21H ; Write one byte
        JMP READ_LOOP ; Loop to read next char
        
END_PROGRAM:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start

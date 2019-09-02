.MODEL SMALL
.STACK 100H

.DATA
        STRING_1 DB 'Prasenjit$'

.CODE
        MAIN PROC
                MOV AX, @DATA
                MOV DS, AX

                LEA DX, STRING_1
                MOV AH, 9
                INT 21H
                MOV AH, 20H
                MOV DL, 0DH
                INT 21H

                MOV DL, 0AH
                INT 21H

                MOV AH, 4CH
                INT 21H
        MAIN ENDP
END MAIN
